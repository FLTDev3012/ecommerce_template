class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show new create edit update destroy]
  before_action :set_order, only: %i[edit update destroy]

  def index
    @orders = Order.includes(:user, order_items: :item).all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.save
      redirect_to @order, notice: "Order created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Order updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, notice: "Order deleted.", status: :see_other
  end

  private

  def set_order
    @order = Order.find_by(id: params[:id])
    unless @order
      redirect_to orders_path, alert: "Order not found."
    end
  end

  def order_params
    params.require(:order).permit(:total_amount, :user_id, order_items_attributes: [:id, :item_id, :item_quantity, :_destroy])
  end

end
