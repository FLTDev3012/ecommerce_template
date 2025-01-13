class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :font, :dashboard ]

  def home
  end

  def font
    @items = Item.all
  end

  def dashboard
    @items = Item.all
    @orders = Order.includes(:user, :order_items).all
  end

end
