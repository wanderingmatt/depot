require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  test "can login" do
    assert User.authenticate('James Howlett', 'coolestxman')
  end
end
