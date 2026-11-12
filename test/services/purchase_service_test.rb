require "test_helper"

class PurchaseServiceTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(id: User::PRECONFIGURED_ID, credits: User::INITIAL_CREDITS)
    @product = Product.new(
      id: "example",
      title: "Example",
      description: "Description",
      content: "Content",
      price: 30
    )
  end

  test "acquiring a product debits credits and records the paid price" do
    PurchaseService.new(user: @user, product: @product).call

    assert_equal 70, @user.reload.credits
    acquisition = @user.acquisitions.find_by!(product_id: "example")
    assert_equal 30, acquisition.paid_price
  end

  test "rejects acquisition without enough credits without changing state" do
    expensive_product = Product.new(
      id: "expensive",
      title: "Expensive",
      description: "Description",
      content: "Content",
      price: 101
    )

    assert_raises(PurchaseService::InsufficientCredits) do
      PurchaseService.new(user: @user, product: expensive_product).call
    end

    assert_equal 100, @user.reload.credits
    assert_empty @user.acquisitions
  end

  test "rejects repeated acquisition without a second debit" do
    service = PurchaseService.new(user: @user, product: @product)
    service.call

    assert_raises(PurchaseService::AlreadyAcquired) { service.call }

    assert_equal 70, @user.reload.credits
    assert_equal 1, @user.acquisitions.count
  end

  test "allows multiple products for the same user" do
    second_product = Product.new(
      id: "second",
      title: "Second",
      description: "Description",
      content: "Content",
      price: 20
    )

    PurchaseService.new(user: @user, product: @product).call
    PurchaseService.new(user: @user, product: second_product).call

    assert_equal 50, @user.reload.credits
    assert_equal 2, @user.acquisitions.count
  end

  test "rolls back the debit when the acquisition is invalid" do
    invalid_product = Product.new(
      id: "",
      title: "Invalid",
      description: "Description",
      content: "Content",
      price: 30
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      PurchaseService.new(user: @user, product: invalid_product).call
    end

    assert_equal 100, @user.reload.credits
    assert_empty @user.acquisitions
  end
end
