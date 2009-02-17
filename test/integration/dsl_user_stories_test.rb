require 'test_helper'

class DslUserStoriesTest < ActionController::IntegrationTest
  fixtures :products

  JAMES_DETAILS = {
    :name     => 'James Howlett',
    :address  => 'X-Mansion',
    :email    => 'wolverine@x-men.com',
    :pay_type => 'check'
  }

  SCOTT_DETAILS = {
    :name     => 'Scott Summers',
    :address  => 'X-Mansion',
    :email    => 'cyclops@x-men.com',
    :pay_type => 'cc'
  }

  def setup
    LineItem.delete_all
    Order.delete_all
    @product_one = products(:one)
    @product_two = products(:two)
  end 

  # A user goes to the index page.
  # The user selects a product, adding it to their cart.
  # They check out, filling in all of their details in the checkout form.
  # They click submit, creating an order with their information along with a single line item corresponding to the product they added to their cart.

  def test_buying_a_product
    james = regular_user
    james.get '/store/index'
    james.is_viewing 'index'
    james.buys_a @product_one
    james.has_a_cart_containing @product_one
    james.checks_out JAMES_DETAILS
    james.is_viewing 'index'
    check_for_order JAMES_DETAILS, @product_one
  end

  def test_two_people_buying
    james = regular_user
    scott = regular_user
    james.buys_a @product_one
    scott.buys_a @product_two
    james.has_a_cart_containing @product_one
    james.checks_out JAMES_DETAILS
    scott.has_a_cart_containing @product_two
    check_for_order JAMES_DETAILS, @product_one
    scott.checks_out SCOTT_DETAILS
    check_for_order SCOTT_DETAILS, @product_two
  end

  def regular_user
    open_session do |user|
      def user.is_viewing(page)
        assert_response :success
        assert_template page
      end

      def user.buys_a product
        xml_http_request :put, '/store/add_to_cart', :id => product.id
        assert_response :success 
      end

      def user.has_a_cart_containing *products
        cart = session[:cart]
        assert_equal products.size, cart.items.size
        for item in cart.items
          assert products.include?(item.product)
        end
      end

      def user.checks_out details
        post '/store/checkout'
        assert_response :success
        assert_template 'checkout'

        post_via_redirect '/store/save_order',
        :order => { :name     => details[:name],
                    :address  => details[:address],
                    :email    => details[:email],
                    :pay_type => details[:pay_type] }
        assert_response :success
        assert_template 'index'
        assert_equal 0, session[:cart].items.size
      end
    end  
  end

  def check_for_order details, *products
    order = Order.find_by_name(details[:name])
    assert_not_nil order

    assert_equal details[:name],     order.name
    assert_equal details[:address],  order.address
    assert_equal details[:email],    order.email
    assert_equal details[:pay_type], order.pay_type

    assert_equal products.size, order.line_items.size
    for line_item in order.line_items
      assert products.include?(line_item.product)
    end
  end
end
