class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }

  before_save :calculate_total_amount

  private

  def calculate_total_amount
    self.total_amount = order_items.sum { |oi| oi.item_quantity.to_f * oi.price_at_order.to_f }
  end


end
