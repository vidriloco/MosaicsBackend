class Admin::OrganizationsController < Admin::BaseController
  
  respond_to :html
  before_filter :authenticate_admin_user!
  
  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])

    if @organization.save
      redirect_to admin_organizations_url, :notice => t('organization.messages.create.success')
    else
      render action: "new"
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes(params[:organization])
      redirect_to admin_organizations_url, :notice => t('organization.messages.update.success')
    else
      render action: "edit"
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    
    redirect_to admin_organizations_url, notice: t('organization.messages.delete.success')
  end
end
