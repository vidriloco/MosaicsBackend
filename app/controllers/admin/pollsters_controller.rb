class Admin::PollstersController <  Admin::BaseController
  
  before_filter :authenticate_admin_user!
  
  # GET /pollsters
  # GET /pollsters.json
  def index
    @pollsters = Pollster.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pollsters }
    end
  end

  # GET /pollsters/1
  # GET /pollsters/1.json
  def show
    @pollster = Pollster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pollster }
    end
  end

  # GET /pollsters/new
  # GET /pollsters/new.json
  def new
    @pollster = Pollster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pollster }
    end
  end

  # GET /pollsters/1/edit
  def edit
    @pollster = Pollster.find(params[:id])
  end

  # POST /pollsters
  # POST /pollsters.json
  def create
    @pollster = Pollster.new(params[:pollster])

    respond_to do |format|
      if @pollster.save
        format.html { redirect_to @pollster, notice: 'Pollster was successfully created.' }
        format.json { render json: @pollster, status: :created, location: @pollster }
      else
        format.html { render action: "new" }
        format.json { render json: @pollster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pollsters/1
  # PUT /pollsters/1.json
  def update
    @pollster = Pollster.find(params[:id])

    respond_to do |format|
      if @pollster.update_attributes(params[:pollster])
        format.html { redirect_to @pollster, notice: 'Pollster was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pollster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pollsters/1
  # DELETE /pollsters/1.json
  def destroy
    @pollster = Pollster.find(params[:id])
    @pollster.destroy

    respond_to do |format|
      format.html { redirect_to pollsters_url }
      format.json { head :ok }
    end
  end
end
