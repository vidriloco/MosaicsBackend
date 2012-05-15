class Admin::MetaSurveysController < Admin::BaseController
  
  before_filter :find_meta_survey, :only => [:destroy, :show, :download]
  before_filter :authenticate_admin_user!
  
  def index
    @meta_surveys = MetaSurvey.all
  end
  
  def new
    @meta_survey = MetaSurvey.new
  end
  
  def create
    @meta_survey = MetaSurvey.register_with(params[:meta_survey])
    
    if @meta_survey.save
      redirect_to admin_meta_surveys_path, :notice => t('meta_survey.messages.create.success')
    else
      render :action => :new
    end
  end
  
  def show
    filename = @meta_survey.name.gsub(/\s+/, "_").downcase
    
    respond_to do |format|
      format.plist do 
        send_data @meta_survey.transform_to_plist, {:type => "text/plist; charset=iso-8859-1; header=present", 
                    :disposition => "attachment; filename=#{filename}.plist" } 
      end
    end
  end
  
  def destroy
    @meta_survey.destroy
    redirect_to admin_meta_surveys_path, :notice => t('meta_survey.messages.delete.success')
  end
  
  def download
    send_data @meta_survey.render_as_csv, {:type => "text/csv; charset=iso-8859-1; header=present",
      :disposition => "attachment; filename=#{@meta_survey.name}.csv" }
  end
  
  private
  def find_meta_survey
    @meta_survey = MetaSurvey.find(params[:id])
  end
end