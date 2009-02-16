class AdminController < ApplicationController
  
  # Places the User's ID in to the session, effectively logging them in.
  # Upon successful logins, we also attempt to redirect the user back to referring page
  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id        
        uri = session[:original_uri]
        session[:original_uri] = nil 
        redirect_to( uri || { :action => "index" } )
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end
  
  # Strips the User's ID from the session, effectively logging them out
  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to( :action => "login" )
  end
  
  def index
    @total_orders = Order.count
  end
end
