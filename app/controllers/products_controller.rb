class ProductsController < ApplicationController
  before_action :load_product, only: %i[show purchase]
  before_action :ensure_product_exists, only: %i[show purchase]
  before_action :set_balance

  def index
    @products = catalog.all
  end

  def show
    @acquired = Acquisition.exists?(user_id: current_user.id, product_id: @product.id)
  end

  def purchase
    PurchaseService.new(user: current_user, product: @product).call
    record_purchase("succeeded")
    redirect_to product_path(@product), notice: "Prompt adquirido com sucesso."
  rescue PurchaseService::AlreadyAcquired
    record_purchase("already_acquired")
    redirect_to product_path(@product), alert: "Este produto já foi adquirido."
  rescue PurchaseService::InsufficientCredits
    record_purchase("insufficient_credits")
    redirect_to product_path(@product), alert: "Saldo insuficiente para adquirir este prompt."
  end

  private

  def catalog
    Rails.application.config.x.product_catalog
  end

  def load_product
    @product = catalog.find(params[:id])
  end

  def ensure_product_exists
    render plain: "Product not found", status: :not_found unless @product
  end

  def set_balance
    @balance = current_user.credits
  end

  def current_user
    @current_user ||= User.preconfigured
  end

  def record_purchase(outcome)
    metrics.increment("purchases_total")
    metrics.increment("purchase_#{outcome}_total")
    Rails.logger.info(
      {
        event: "purchase",
        outcome: outcome,
        user_id: current_user.id,
        product_id: @product.id,
        price: @product.price
      }.to_json
    )
  end

  def metrics
    Rails.application.config.x.metrics
  end
end
