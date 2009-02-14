require 'test_helper'
 
class CartItemTest < ActiveSupport::TestCase
  def test_initialize
    cart_item = CartItem.new(products(:one))
    assert_equal 1, cart_item.quantity
  end
  
  def test_increment_quantity
    cart_item = CartItem.new(products(:one))
    cart_item.increment_quantity
    assert_equal 2, cart_item.quantity
  end
 
  def test_title
    cart_item = CartItem.new(products(:one))
    assert_equal products(:one).title, cart_item.title
  end
 
  def test_price
    cart_item = CartItem.new(products(:one))
    assert_equal products(:one).price, cart_item.price.to_i
  end
end