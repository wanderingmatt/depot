require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  def setup
    @request.session[:user_id] = users(:one).id
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, :order => { 
        :name     => 'James Howlett', 
        :address  => 'X-Mansion', 
        :email    => 'wolverine@x-men.com', 
        :pay_type => 'check' 
      }
    end

    assert_redirected_to order_path(assigns(:order))
  end
  
  test "should error on invalid order" do
    assert_difference('Order.count', 0) do    
      post :create, :order => {
        :name     => '', 
        :address  => 'X-Mansion', 
        :email    => 'wolverine@x-men.com', 
        :pay_type => 'check'
      }
    end
    
    assert_not_nil assigns(:order).errors.on :name
  end

  test "should show order" do
    get :show, :id => orders(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => orders(:one).id
    assert_response :success
  end

  test "should update order" do
    put :update, :id => orders(:one).id, :order => { 
      :pay_type => "cc"    
    }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, :id => orders(:one).id
    end

    assert_redirected_to orders_path
  end
end
