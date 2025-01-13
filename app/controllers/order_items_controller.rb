class OrderItemsController < ApplicationController

  before_action :set_order_item, only: [:destroy, :update_quantity]
  before_action :set_order, only: [:create]

  def create
    item = Item.find(params[:item_id])
    order_item = @order.order_items.find_by(item: item)

    if order_item
      # Si l'article est déjà dans la commande, on augmente la quantité
      order_item.update(item_quantity: order_item.item_quantity + params[:item_quantity].to_i)
    else
      # Sinon, on ajoute un nouvel article
      @order.order_items.create!(item: item, item_quantity: params[:item_quantity], price_at_order: item.price)
    end

    # Mettre à jour le total de la commande
    @order.update!(total_amount: @order.order_items.sum { |oi| oi.item_quantity * oi.price_at_order })

    redirect_to items_path, notice: "#{item.name} added to order."
  end

  def update_quantity
    if @order_item.update(item_quantity: params[:order_item][:item_quantity].to_i)
      @order_item.order.update!(total_amount: @order_item.order.order_items.sum { |oi| oi.item_quantity * oi.price_at_order })
      redirect_to edit_order_path(@order_item.order), notice: "Quantity updated successfully."
    else
      redirect_to edit_order_path(@order_item.order), alert: "Failed to update quantity."
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

end
