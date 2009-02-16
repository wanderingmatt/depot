class InfoController < ApplicationController
  
  # An easily accessible action that returns a list of orders for a specific product in HTML, ATOM, XML or JSON
  # XML Example: http://localhost:3000/info/who_bought/1.xml
  def who_bought
    @product = Product.find(params[:id])
    @orders = @product.orders
    respond_to do |format|
      format.html
      format.atom { render :layout => false }
      format.xml { render  :layout => false,
                           :xml    => @product.to_xml( :include => :orders ) }
      format.json { render :layout => false,
                           :json   => @product.to_json( :include => :orders ) }
    end
  end
  
  
  protected
  
  
  def authorize
  end
end
