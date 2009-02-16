require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  test "can login" do
    assert User.authenticate('James Howlett', 'coolestxman')
  end
  
  test "should not delete last user" do  
    users = User.find(:all)
    assert_raise(RuntimeError) do
      loop do
        users.first.destroy
        users.shift
      end
    end

    assert_equal 1, users.length
  end
end
