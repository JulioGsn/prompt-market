class Acquisition < ApplicationRecord
  belongs_to :user

  validates :product_id, presence: true, uniqueness: { scope: :user_id }
  validates :paid_price, numericality: { only_integer: true, greater_than: 0 }
end
