class Admin::MetaSurveysController < ApplicationController
  layout 'admin'
  
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
      redirect_to admin_meta_surveys_path
    else
      render :action => :new
    end
  end
end