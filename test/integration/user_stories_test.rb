require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :products
  
  # A user goes to the index page.
  # The user selects a product, adding it to their cart.
  # They check out, filling in all of their details in the checkout form.
  # They click submit, creating an order with their information along with a single line item corresponding to the product they added to their cart.
  
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    product = products(:one)
    
    get '/store/index'
    assert_response :success
    assert_template 'index'
    
    xml_http_request :put, '/store/add_to_cart', :id => product.id
    assert_response :success
    
    cart = session[:cart]
    assert_equal 1, cart.items.size
    assert_equal product, cart.items[0].product
    
    post '/store/checkout'
    assert_response :success
    assert_template 'checkout'
    
    post_via_redirect '/store/save_order',
                      :order => { :name     => 'James Howlett',
                                  :address  => 'X-Mansion',
                                  :email    => 'wolverine@x-men.com',
                                  :pay_type => 'check' }
    assert_response :success
    assert_template 'index'
    assert_equal 0, session[:cart].items.size
    
    orders = Order.find(:all)
    assert_equal 1, orders.size
    order = orders[0]
    
    assert_equal 'James Howlett',       order.name
    assert_equal 'X-Mansion',           order.address
    assert_equal 'wolverine@x-men.com', order.email
    assert_equal 'check',               order.pay_type
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal product, line_item.product
  end
end
