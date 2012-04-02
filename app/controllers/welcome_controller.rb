class WelcomeController < ApplicationController
  layout 'welcome'
  before_filter :redirect_if_logged_in, :only => [:access]
  
  def index
    
  end
  
  def access
    
  end
  
  private
  def redirect_if_logged_in
    
  end
end
