class Api::SessionsController < ApplicationController
  protect_from_forgery :except => [:authenticate]
  
  respond_to :json
  
  def authenticate
    @pollster = Pollster.check_credentials(params[:pollster])
    
    if @pollster
      render :json => @pollster
    else
      render(:status => :forbidden, :nothing => true)
    end
  end
  
end