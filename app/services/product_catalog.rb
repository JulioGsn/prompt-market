require "json"

class ProductCatalog
  class InvalidCatalog < StandardError; end

  REQUIRED_KEYS = %w[id title description content price].freeze

  def initialize(path: Rails.root.join("data/products.json"))
    @products = load_products(path)
  end

  def all
    @products.values
  end

  def find(id)
    @products[id.to_s]
  end

  private

  def load_products(path)
    raw_products = JSON.parse(File.read(path))
    invalid("catalog root must be an array") unless raw_products.is_a?(Array)

    products = raw_products.map.with_index do |attributes, index|
      build_product(attributes, index)
    end

    ids = products.map(&:id)
    invalid("product ids must be unique") if ids.uniq.length != ids.length

    products.index_by(&:id).freeze
  rescue Errno::ENOENT => error
    raise InvalidCatalog, "catalog file could not be read: #{error.message}"
  rescue JSON::ParserError => error
    raise InvalidCatalog, "catalog contains invalid JSON: #{error.message}"
  end

  def build_product(attributes, index)
    invalid("product at index #{index} must be an object") unless attributes.is_a?(Hash)

    missing_keys = REQUIRED_KEYS.reject { |key| attributes.key?(key) }
    invalid("product at index #{index} is missing: #{missing_keys.join(', ')}") if missing_keys.any?

    string_keys = %w[id title description content]
    string_keys.each do |key|
      value = attributes[key]
      valid_string = value.is_a?(String) && value.strip != ""
      invalid("product at index #{index} has an invalid #{key}") unless valid_string
    end

    price = attributes["price"]
    invalid("product at index #{index} must have a positive integer price") unless price.is_a?(Integer) && price.positive?

    Product.new(
      id: attributes["id"],
      title: attributes["title"],
      description: attributes["description"],
      content: attributes["content"],
      price: price
    )
  end

  def invalid(message)
    raise InvalidCatalog, message
  end
end
