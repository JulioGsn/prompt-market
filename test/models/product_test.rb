require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "product is immutable after creation" do
    product = Product.new(
      id: "example",
      title: "Example",
      description: "Description",
      content: "Content",
      price: 10
    )

    assert_predicate product, :frozen?
  end
end
