require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  test "can login" do
    assert User.authenticate('James Howlett', 'coolestxman')
  end
  
  test "should not delete last user" do
    assert_raise RuntimeError do
      @users = User.find(:all)
      for user in @users
        user.destroy
      end
      
      assert flash[:notice]
    end
  end
end
