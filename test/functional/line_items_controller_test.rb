require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, :line_item => { 
        :product_id => 1, 
        :order_id => 6, 
        :quantity => 2, 
        :total_price => 40.0 
      }
    end

    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should show line_item" do
    get :show, :id => line_items(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => line_items(:one).id
    assert_response :success
  end

  test "should update line_item" do
    put :update, :id => line_items(:one).id, :line_item => {
      :quantity => 2, 
    }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, :id => line_items(:one).id
    end

    assert_redirected_to line_items_path
  end
  
  def test_from_cart_item
    product = products(:one)
    cart_item = CartItem.new product
    line_item = LineItem.from_cart_item(cart_item)
    
    assert_equal products(:one), line_item.product
    assert_equal 1, line_item.quantity
    assert_equal products(:one).price, line_item.total_price
  end
  
  def test_from_cart_itemcart_with_many
    product = products(:one)
    cart_item = CartItem.new product
    cart_item.increment_quantity
    line_item = LineItem.from_cart_item(cart_item)
    
    assert_equal products(:one), line_item.product
    assert_equal 2, line_item.quantity
    assert_equal cart_item.price, line_item.total_price
  end
  
  def test_line_item_can_has_order
    line_item = line_items(:one)
    line_item.order = orders(:one)
    assert_equal(orders(:one), line_item.order)
  end
end
