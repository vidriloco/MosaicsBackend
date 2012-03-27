class Manager::MainController < ApplicationController
  
  before_filter :authenticate_manager!
  
  def index
    @manager = current_manager
    
    render :layout => 'welcome'
  end
end

