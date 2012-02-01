class Admin::MainController < ApplicationController
  layout 'admin'
  
  before_filter :authenticate_admin_user!
  
  def index
  end
end