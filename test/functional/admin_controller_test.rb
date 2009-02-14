require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "needs authentication" do
    get :index
    assert_response :redirect
    assert_redirected_to :controller => 'admin', :action => 'login'
  end

  test "i am logged in" do
    @request.session[:user_id] = users(:one).id
    get :index
    assert_response :success
  end
end
