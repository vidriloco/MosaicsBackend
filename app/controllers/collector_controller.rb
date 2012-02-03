class CollectorController < ApplicationController
  protect_from_forgery :except => :commit
  
  def commit
    @survey = Survey.from_json(params[:survey])
    
    if @survey.save
      render(:nothing => true)
    else
      render(:nothing => true, :status => :unprocessable_entity)
    end
  end
end