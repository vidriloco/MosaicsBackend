class WelcomeController < ApplicationController
  layout 'welcome'
  
  before_filter :authenticate_manager!
  
  def index
    @manager = current_manager  
  end
end
