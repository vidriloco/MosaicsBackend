class Admin::MetaSurveysController < Admin::BaseController
  
  before_filter :find_meta_survey, :only => [:destroy, :show, :download, :purge]
  before_filter :authenticate_admin_user!, :except => [:download]
  
  def index
    @meta_surveys = MetaSurvey.all
  end
  
  def new
    @meta_survey = MetaSurvey.new
  end
  
  def create
    @meta_survey = MetaSurvey.register_with(params[:meta_survey], params[:campaign])
    
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
        send_data @meta_survey.transform_to_plist, {
          :type => "text/plist; charset=iso-8859-1; header=present", 
          :disposition => "attachment; filename=#{filename}.plist" 
          } 
      end
    end
  end
  
  def destroy
    @meta_survey.destroy
    redirect_to admin_meta_surveys_path, :notice => t('meta_survey.messages.delete.success')
  end
  
  def download
    if admin_user_signed_in? || manager_signed_in?
      send_data @meta_survey.render_as_csv_string, {
        :type => "text/csv; charset=iso-8859-1; header=present",
        :disposition => "attachment; filename=#{@meta_survey.name.gsub(' ', '_')}.csv" 
        }
    end
  end
  
  def purge
    @meta_survey.surveys.destroy_all
    redirect_to admin_meta_surveys_path
  end
  
  private
  def find_meta_survey
    @meta_survey = MetaSurvey.find(params[:id])
  end
end