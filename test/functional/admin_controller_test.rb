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
  
  # test "login handles bad user" do
  # end
  # 
  # test "login handles bad password" do
  #   post :login, :info => { :name => @user.name, :password => 'jank' }
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
