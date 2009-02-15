require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @request.session[:user_id] = users(:one).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => {
        :name => "Kurt Wagner",
        :password => "darkestxman",
        :password_confirmation => "darkestxman"
      }
    end

    assert_redirected_to :action => 'index'
  end
  
  test "should not create user with invalid name" do
    assert_difference('User.count', 0) do    
      post :create, :user => { :name => '' }
    end
    
    assert_not_nil assigns(:user).errors.on :name
  end
  
  test "should not create duplicate user" do
    assert_difference('User.count', 0) do    
      post :create, :user => { :name => users(:one).name }
    end
    
    assert_not_nil assigns(:user).errors.on :name
  end
  
  test "should confirm password on create" do
    assert_difference('User.count', 0) do    
      post :create, :user => {
        :name => "Kurt Wagner",
        :password => "darkestxman",
        :password_confirmation => "darkestxmen"
      }
    end
    
    assert_not_nil assigns(:user).errors.on :password
  end

  test "should show user" do
    get :show, :id => users(:one).id
    assert_response :success
  end
  
  test "should not show invalid user" do
    get :show, :id => User.maximum(:id) + 1

    assert_response :redirect
    assert flash[:notice]
  end

  test "should get edit" do
    get :edit, :id => users(:one).id
    assert_response :success
  end
  
  test "should not edit invalid user" do
    get :edit, :id => User.maximum(:id) + 1

    assert_response :redirect
    assert flash[:notice]
  end

  test "should update user" do
    put :update, :id => users(:one).id, :user => {
      :name => 'Logan',
    }
    assert_redirected_to :action => 'index'
  end
  
  test "should not update invalid user" do
    get :update, :id => User.maximum(:id) + 1

    assert_response :redirect
    assert flash[:notice]
  end
  
  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).id
    end

    assert_redirected_to users_path
  end
  
  test "should not destroy invalid user" do
    delete :destroy, :id => User.maximum(:id) + 1

    assert_response :redirect
    assert flash[:notice]
  end
end
