require 'test_helper'
require 'store_controller'

class OrderSpeedTest < ActionController::TestCase
  tests StoreController
  
  JAMES_DETAILS = {
    :name     => 'James Howlett',
    :address  => 'X-Mansion',
    :email    => 'wolverine@x-men.com',
    :pay_type => 'check'
  }
  
  self.fixture_path = File.join(File.dirname(__FILE__), "../fixtures/performance")
  fixtures :products
  
  def test_100_orders
    Order.delete_all
    LineItem.delete_all

    @controller.logger.silence do
      elapsed_time = Benchmark.realtime do
        100.downto(1) do |prd_id|
          cart = Cart.new
          cart.add_product(Product.find(prd_id))
          post :save_order, 
               { :order => JAMES_DETAILS },
               { :cart  => cart }
          assert_redirected_to :action => :index
        end         
      end       
      assert_equal 100, Order.count
      assert elapsed_time < 3.00 
    end  
  end
end
