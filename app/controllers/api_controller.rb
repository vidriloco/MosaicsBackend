class ApiController < ApplicationController
  protect_from_forgery :except => [:collect]
  
  before_filter :find_meta_survey, :except => [:collect]
  
  def collect    
    @survey=Pollster.digest_survey_from(params[:survey])
      
    if @survey && @survey.save
      render(:nothing => true)
    else
      render(:nothing => true, :status => :unprocessable_entity)
    end    
  end
  
  def whiteboard
  end
  
  def new
    
    respond_to do |format|
      format.js
    end
  end
  
  def results
    send_attrs = {:type => "text/#{params[:format]}; charset=iso-8859-1; header=present", 
                  :disposition => "attachment; filename=#{@meta_survey.name}.#{params[:format]}" }
                  
    respond_to do |format|
      format.xls { send_data @meta_survey.surveys_to_xls, send_attrs }
      format.csv { send_data @meta_survey.surveys_to_csv, send_attrs }
    end
  end
  
  private
  def find_meta_survey
    @meta_survey = MetaSurvey.find(params[:meta_survey_id])
  end
end