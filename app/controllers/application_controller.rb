class ApplicationController < ActionController::Base
  protect_from_forgery  
  def after_sign_in_path_for(resource)
    return '/managers' if resource.is_a? Manager
    '/admin'
  end
  
end
