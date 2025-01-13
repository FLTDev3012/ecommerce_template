class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  validates :item_quantity, numericality: { greater_than: 0 }
  validates :price_at_order, numericality: { greater_than_or_equal_to: 0 }
end
