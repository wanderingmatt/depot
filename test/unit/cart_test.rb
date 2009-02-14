require 'test_helper'
 
class CartTest < ActiveSupport::TestCase
  def test_initialize
    cart = Cart.new
    assert_equal 0, cart.items.length
  end
  
  def test_add_product
    cart = Cart.new
    cart << products(:one)
    assert_equal 1, cart.items.length
  end
  
  def test_add_multiple_products
    cart = Cart.new
    cart << products(:one)
    cart << products(:two)
    assert_equal 2, cart.items.length
  end
  
  def test_add_same_product_multiple_times
    cart = Cart.new
    6.times { cart << products(:one) }
    assert_equal 6, cart.items.first.quantity
  end
  
  def test_total_items
    cart = Cart.new
    cart << products(:one)
    cart << products(:two)
    assert_equal 2, cart.total_items
  end
  
  def test_total_price
    cart = Cart.new
    cart << products(:one)
    cart << products(:two)
    assert_equal products(:one).price + products(:two).price, cart.total_price
  end
end