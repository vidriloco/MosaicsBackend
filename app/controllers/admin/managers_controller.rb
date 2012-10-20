class Admin::ManagersController < Admin::BaseController
  
  before_filter :find_manager, :only => [:edit, :update, :destroy]
  before_filter :authenticate_admin_user!
  
  respond_to :html
  
  # GET /admin_users
  def index
    @managers = Manager.all
  end

  # GET /admin_users/new
  def new
    @manager = Manager.new
  end

  # GET /admin_users/1/edit
  def edit
  end

  # POST /admin_users
  def create
    @manager = Manager.new(params[:manager])

    if @manager.save
      redirect_to admin_managers_path, :notice => I18n.t('manager.messages.creation')
    else
      render action: "new"
    end
  end

  # PUT /admin_users/1
  def update

    if @manager.update_attributes(params[:manager])
      redirect_to admin_managers_path, notice: I18n.t('manager.messages.modification')
    else
      render action: "edit"
    end
  end

  # DELETE /admin_users/1
  def destroy
    @manager.destroy

    redirect_to managers_url
  end
  
  private
  def find_manager
    @manager = Manager.find(params[:id])
  end
end
