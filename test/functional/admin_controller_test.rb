require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "requires authentication" do
    get :index
    
    assert_response :redirect
    assert_redirected_to :controller => 'admin', :action => 'login'
  end

  test "is logged in" do
    @request.session[:user_id] = users(:one).id
    get :index
    
    assert_response :success
  end

  test "logs user in" do
    post :login, :name => @user.name, :password => 'coolestxman'
    
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_equal @user.id, session[:user_id]
  end

  test "logs user in and remembers referring uri" do
    uri = 'http://localhost:3000/users'
    @request.session[:original_uri] = uri
    post :login, :name => @user.name, :password => 'coolestxman'
    
    assert_nil @request.session[:original_uri]
    assert_response :redirect
    assert_redirected_to uri
  end

  ## Can't figure these out - awaiting feedback from Aaron
  #
  # test "login handles invalid user name" do
  #   post :login, :name => '', :password => 'coolestxman'
  # 
  #   assert assigns(:admin).errors.on :name
  #   assert flash[:notice]
  # end
  # 
  # test "login handles invalid password" do
  #   post :login, :name => @user.name, :password => 'jank'
  # 
  #   assert_not_nil assigns(:admin).errors.on :password
  #   assert flash[:notice]
  # end
  
  test "logs user out" do
    post :login, :name => @user.name, :password => 'coolestxman'
    @request.session[:user_id] = users(:one).id
    post :logout
    
    assert_nil @request.session[:user_id]
    assert_response :redirect
    assert_redirected_to :action => 'login'
    assert flash[:notice]
  end
end
