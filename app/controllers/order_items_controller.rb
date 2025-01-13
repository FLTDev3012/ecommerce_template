class OrderItemsController < ApplicationController

  before_action :set_order_item, only: [:destroy, :update_quantity]
  before_action :set_order, only: [:create]

  def create
    item = Item.find(params[:item_id])

    # Vérifie si l'utilisateur a déjà une commande en cours (status: "pending"), sinon, il en crée une
    @order ||= current_user.orders.find_or_create_by(status: "pending")

    # Vérifie que l'ordre est bien sauvegardé avant d'ajouter un OrderItem
    unless @order.persisted?
      @order.save!
    end

    order_item = @order.order_items.find_by(item: item)

    if order_item
      # Si l'article est déjà dans la commande, on augmente la quantité
      order_item.update!(item_quantity: order_item.item_quantity + params[:item_quantity].to_i)
    else
      # Sinon, on ajoute un nouvel article
      @order.order_items.create!(item: item, item_quantity: params[:item_quantity].to_i, price_at_order: item.price)
    end

    # Mettre à jour le total de la commande
    @order.update!(total_amount: @order.order_items.sum { |oi| oi.item_quantity * oi.price_at_order })

    redirect_to items_path, notice: "#{item.name} added to order."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to items_path, alert: "Failed to add item: #{e.message}"
  end



  def update_quantity
    @order_item = OrderItem.find(params[:id])

    if params[:order_item].present? && params[:order_item][:item_quantity].present?
      new_quantity = params[:order_item][:item_quantity].to_i
      if @order_item.update(item_quantity: new_quantity)
        @order_item.order.update!(total_amount: @order_item.order.order_items.sum { |oi| oi.item_quantity * oi.price_at_order })
        redirect_to edit_order_path(@order_item.order), notice: "Quantité mise à jour avec succès."
      else
        redirect_to edit_order_path(@order_item.order), alert: "Erreur lors de la mise à jour."
      end
    else
      redirect_to edit_order_path(@order_item.order), alert: "Erreur : paramètres invalides."
    end
  end

  def destroy
    order = @order_item.order
    @order_item.destroy
    order.update!(total_amount: order.order_items.sum { |oi| oi.item_quantity * oi.price_at_order })

    redirect_to edit_order_path(order), notice: "Item removed successfully."
  end

  private

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def set_order
    if current_user.nil?
      redirect_to new_user_session_path, alert: "You need to sign in to place an order."
    else
      # Si l'utilisateur a déjà une commande en cours (pending), on la récupère, sinon on en crée une nouvelle
      @order = current_user.orders.find_or_create_by(status: "pending")
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:item_quantity)
  end

end
