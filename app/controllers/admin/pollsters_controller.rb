class Admin::PollstersController <  Admin::BaseController
  
  before_filter :authenticate_admin_user!
  
  # GET /pollsters
  def index
    @pollsters = Pollster.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /pollsters/1
  def show
    @pollster = Pollster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /pollsters/new
  def new
    @pollster = Pollster.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /pollsters/1/edit
  def edit
    @pollster = Pollster.find(params[:id])
  end

  # POST /pollsters
  def create
    @pollster = Pollster.new(params[:pollster])

    respond_to do |format|
      if @pollster.save
        format.html { redirect_to admin_pollster_path(@pollster), notice: 'Pollster was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /pollsters/1
  def update
    @pollster = Pollster.find(params[:id])

    respond_to do |format|
      if @pollster.update_attributes(params[:pollster])
        format.html { redirect_to admin_pollster_path(@pollster), notice: 'Pollster was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /pollsters/1
  # DELETE /pollsters/1.json
  def destroy
    @pollster = Pollster.find(params[:id])
    @pollster.destroy

    respond_to do |format|
      format.html { redirect_to admin_pollsters_url }
    end
  end
end
