class StoreController < ApplicationController
  def index
    @cart = find_cart
    @products = Product.find_products_for_sale
  end
  
  def add_to_cart # TODO Cart should have it's own controller
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index('Invalid product')
    else
      @cart = find_cart
      @current_item = @cart.add_product(product)
      respond_to do |format|
        format.js if request.xhr?
        format.html { redirect_to_index('The item was successfully added to your cart') }
      end
    end
  end
  
  def empty_cart
    session[:cart] = nil
    respond_to do |format|
      format.js if request.xhr?
      format.html { redirect_to_index('Your cart is currently empty') }
    end
  end
  
  def checkout
    @cart = find_cart
    if @cart.items.empty?
      redirect_to_index('Your cart is currently empty')
    else
      @order = Order.new
    end
  end
  
  def save_order
    @cart = find_cart
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
      session[:cart] = nil
      redirect_to_index('Thank you for your order!')
    else
      render :action => 'checkout'
    end
  end

  
  
  private


  def redirect_to_index message = nil
    flash[:notice] = message if message
    redirect_to :action => 'index'
  end
  
  def find_cart 
    session[:cart] ||= Cart.new # If there is no cart in the session, create a new one
  end
end
