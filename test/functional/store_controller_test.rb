require 'test_helper'
require 'yaml'

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
  
  test "locale is en by default" do
    get :index
    
    assert_equal I18n.locale, 'en'
  end
  
  test "changing the locale results in translation" do
    en = YAML::load(File.open("#{LOCALES_DIRECTORY}en.yml"))    
    es = YAML::load(File.open("#{LOCALES_DIRECTORY}es.yml"))    
    
    @request.session[:locale] = I18n.locale
    get :index
    
    assert_equal @request.session[:locale], 'en'
    assert_tag :tag => 'h1', :content => en['en']['main']['title']
    
    @request.session[:locale] = 'es'
    get :index
    
    assert_equal @request.session[:locale], 'es'
    assert_tag :tag => 'h1', :content => es['es']['main']['title']
  end
end
