class ApiController < ApplicationController
  protect_from_forgery :except => :commit
  
  def collect
    @survey = params[:survey].is_a?(String) ? Survey.from_json(params[:survey]) : Survey.from_hash(params[:survey])
    
    if @survey.save
      render(:nothing => true)
    else
      render(:nothing => true, :status => :unprocessable_entity)
    end
  end
  
  def whiteboard
  end
  
  def new
    @meta_survey = MetaSurvey.find(params[:meta_survey_id])
    
    respond_to do |format|
      format.js
    end
  end
end