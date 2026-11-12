class User < ApplicationRecord
  PRECONFIGURED_ID = 1
  INITIAL_CREDITS = 100

  has_many :acquisitions, dependent: :restrict_with_exception

  validates :credits, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.preconfigured
    find_or_create_by!(id: PRECONFIGURED_ID) do |user|
      user.credits = INITIAL_CREDITS
    end
  end
end
