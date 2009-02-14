require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    Product.find_products_for_sale.each do |product|
      assert_tag :tag => 'h3', :content => product.title
      assert_match /#{sprintf("%01.2f", product.price)}/, @response.body
    end
  end
  
  test "session contains cart" do
    get :index
    assert session[:cart]
  end
  
  test "add_to_cart adds a product to the cart" do
    post :add_to_cart, :id => products(:one).id
    assert_response :redirect
    assert flash[:notice]
    assert cart = assigns(:cart)
    assert_equal 1, cart.items.length
  end
  
  test "cart handles invalid id" do
    post :add_to_cart, :id => Product.maximum(:id) + 1
    assert_response :redirect
    assert flash[:notice]
  end
  
  test "empty_cart empties the cart" do
    post :empty_cart
    assert_nil session[:cart]
    assert_response :redirect
    assert flash[:notice]
  end
  
  test "checkout should succeed with a full cart" do
    post :add_to_cart, :id => products(:one).id
    post :checkout
    assert_response :success
  end
  
  test "checkout should redirect with an empty cart" do
    post :checkout
    assert_response :redirect
    assert flash[:notice]
  end

  # test "save_order empties cart" do
  #   @request.session[:cart] = Cart.new
  #   @request.session[:cart].add_product(products(:one))
  #   
  #   post :save_order, :order  => {}
  #   assert_nil session[:cart]
  #   assert_redirected_to :controller => :store, :action => 'index'
  # end
end
