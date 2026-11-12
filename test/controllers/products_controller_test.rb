require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Acquisition.delete_all
    User.delete_all
    User.create!(id: User::PRECONFIGURED_ID, credits: User::INITIAL_CREDITS)
  end

  test "index lists public product information without revealing content" do
    get products_url

    assert_response :success
    assert_select "h1#catalog-title", text: "Escolha uma ferramenta para o próximo trabalho."
    assert_select "article.product-card", count: 3
    assert_select "h2", text: "Análise de requisitos"
    assert_select ".status", text: "saldo: 100 créditos"
    refute_includes response.body, "Atue como um analista de requisitos experiente"
  end

  test "show renders public product information without revealing content" do
    get product_url(id: "analise-de-requisitos")

    assert_response :success
    assert_select "h1", text: "Análise de requisitos"
    assert_select ".detail-price", text: "25 créditos"
    assert_select "form[action='/products/analise-de-requisitos/purchase']"
    refute_includes response.body, "Atue como um analista de requisitos experiente"
  end

  test "purchase redirects to the product and reveals its content" do
    post purchase_product_url(id: "analise-de-requisitos")

    assert_redirected_to product_url(id: "analise-de-requisitos")
    follow_redirect!
    assert_response :success
    assert_select ".flash-notice", text: "Prompt adquirido com sucesso."
    assert_select "#content-title", text: "Conteúdo completo"
    assert_includes response.body, "Atue como um analista de requisitos experiente"
    refute_select "form[action='/products/analise-de-requisitos/purchase']"
    assert_select ".status", text: "saldo: 75 créditos"
  end

  test "repeated purchase does not charge again" do
    post purchase_product_url(id: "analise-de-requisitos")
    post purchase_product_url(id: "analise-de-requisitos")

    assert_redirected_to product_url(id: "analise-de-requisitos")
    follow_redirect!
    assert_select ".flash-alert", text: "Este produto já foi adquirido."
    assert_select ".status", text: "saldo: 75 créditos"
  end

  test "show returns not found for an unknown product" do
    get product_url(id: "does-not-exist")

    assert_response :not_found
    assert_equal "Product not found", response.body
  end
end
