class Product
  attr_reader :id, :title, :description, :content, :price

  def initialize(id:, title:, description:, content:, price:)
    @id = id
    @title = title
    @description = description
    @content = content
    @price = price
    freeze
  end

  def to_param
    id
  end
end
