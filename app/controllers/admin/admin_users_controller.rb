class Admin::AdminUsersController < Admin::BaseController
  
  before_filter :find_admin_user, :only => [:edit, :update, :destroy]
  before_filter :authenticate_admin_user!
  
  respond_to :html
  
  # GET /admin_users
  def index
    @admin_users = AdminUser.all
  end

  # GET /admin_users/new
  def new
    @admin_user = AdminUser.new
  end

  # GET /admin_users/1/edit
  def edit
  end
  
  def show
  end

  # POST /admin_users
  def create
    @admin_user = AdminUser.new(params[:admin_user])

    if @admin_user.save
      redirect_to admin_admin_users_path, :notice => 'Admin user was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin_users/1
  def update

    if @admin_user.update_attributes(params[:admin_user])
      redirect_to admin_admin_users_path, notice: 'Admin user was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin_users/1
  def destroy
    @admin_user.destroy

    redirect_to admin_users_url
  end
  
  private
  def find_admin_user
    @admin_user = AdminUser.find(params[:id])
  end
end
