require "test_helper"
require "tempfile"

class ProductCatalogTest < ActiveSupport::TestCase
  test "loads the versioned catalog" do
    catalog = ProductCatalog.new

    assert_equal 3, catalog.all.length
    assert_equal "Análise de requisitos", catalog.find("analise-de-requisitos").title
    assert_predicate catalog.find("analise-de-requisitos").price, :positive?
  end

  test "rejects a catalog with a non-integer price" do
    Tempfile.create([ "products", ".json" ]) do |file|
      file.write([ { "id" => "invalid", "title" => "Title", "description" => "Description", "content" => "Content", "price" => 10.5 } ].to_json)
      file.flush

      error = assert_raises(ProductCatalog::InvalidCatalog) { ProductCatalog.new(path: file.path) }

      assert_includes error.message, "positive integer price"
    end
  end

  test "rejects duplicate product ids" do
    Tempfile.create([ "products", ".json" ]) do |file|
      product = { "id" => "duplicate", "title" => "Title", "description" => "Description", "content" => "Content", "price" => 10 }
      file.write([ product, product ].to_json)
      file.flush

      assert_raises(ProductCatalog::InvalidCatalog) { ProductCatalog.new(path: file.path) }
    end
  end
end
