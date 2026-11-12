Rails.application.config.to_prepare do
  Rails.application.config.x.product_catalog = ProductCatalog.new
end
