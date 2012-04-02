# encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Login & control:" do
  
  describe "If logged-in" do
    
    before(:each) do
      @admin = Factory(:admin_user)
      login_with(@admin, new_admin_user_session_path)
    end
    
    scenario "it should send me to the main panel page" do
      current_path.should == admin_index_path
      
      page.should have_content I18n.t('general.messages.welcome')
      
=begin      find_link I18n.t(Pollster.model_name.human)
      find_link I18n.t(Devise.model_name.human)
      find_link I18n.t(Organization.model_name.human)
      find_link I18n.t(User.model_name.human)
=end
    end
    
  end
  
  describe "If NOT logged-in" do
    
    scenario "attempting to visit the administration panel should redirect me to the login page" do
      visit admin_index_path
      current_path.should == new_admin_user_session_path
    end
    
  end
    
end