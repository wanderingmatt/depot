class StoreController < ApplicationController
  def index
    find_cart
    @products = Product.find_products_for_sale
    @page_title = 'Wandering Comics'
  end
  
  def add_to_cart # TODO Cart should have it's own controller
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index('Invalid product')
    else
      @cart = find_cart
      @cart.add_product(product)
    end
  end
  
  def empty_cart
    session[:cart] = nil
    redirect_to_index('Your cart is currently empty')
  end
  
  
  private


  def redirect_to_index(message)
    flash[:notice] = message
    redirect_to :action => 'index'
  end
  
  def find_cart 
    session[:cart] ||= Cart.new # If there is no cart in the session, create a new one
  end
end
