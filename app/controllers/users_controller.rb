class UsersController < ApplicationController
  def setup
    @request.session[:user_id] = users(:one).id
  end

  def index
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid user #{params[:id]}")
      redirect_to_index('Invalid user')
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def edit
    @user = User.find(params[:id])
    
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid user #{params[:id]}")
      redirect_to_index('Invalid user')
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid user #{params[:id]}")
      redirect_to_index('Invalid user')
    else
      respond_to do |format|
        if @user.update_attributes(params[:user])
          flash[:notice] = "User #{@user.name} was successfully updated."
          format.html { redirect_to :action => 'index' }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    begin
      @user = User.find(params[:id])
      begin 
        flash[:notice] = "User #{@user.name} deleted" 
        @user.destroy 
      rescue Exception => e 
        flash[:notice] = e.message 
      end
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid user #{params[:id]}")
      redirect_to_index('Invalid user')
    else
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    end
  end
  
  
  private
  
  
  def redirect_to_index message = nil
    flash[:notice] = message if message
    redirect_to :action => 'index'
  end
end
