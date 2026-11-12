class PurchaseService
  class AlreadyAcquired < StandardError; end
  class InsufficientCredits < StandardError; end

  def initialize(user:, product:)
    @user = user
    @product = product
  end

  def call
    Acquisition.transaction do
      raise AlreadyAcquired, "product already acquired" if Acquisition.exists?(user_id: @user.id, product_id: @product.id)

      credits_update = User.sanitize_sql_array([ "credits = credits - ?", @product.price ])
      updated_users = User.where(id: @user.id).where("credits >= ?", @product.price).update_all(credits_update)
      raise InsufficientCredits, "insufficient credits" unless updated_users == 1

      Acquisition.create!(user: @user, product_id: @product.id, paid_price: @product.price)
    rescue ActiveRecord::RecordNotUnique
      raise AlreadyAcquired, "product already acquired"
    end
  end
end
