# encoding: utf-8
require 'acceptance/acceptance_helper'

feature "A manager can review it's organization's surveys:" do
  
  before(:each) do
    @organization = Factory(:organization, :name => "KantarWorldPanel")
    @manager = Factory(:manager, :organization => @organization)
  end
  
  scenario "Attempting to visit my project survey page if not logged-in" do
    visit manager_root_path
    current_path.should == new_manager_session_path
  end
  
  describe "Being logged-in as a manager" do
    
    before(:each) do
      login_with(@manager, new_manager_session_path)
    end
        
    it "with no projects registered I should not see any listed" do
      common_contents_for(@organization, @manager)
      
      within('#content') do
        page.should have_content I18n.t('organization.views.index.projects.empty')
      end
    end
          
    describe "and given a survey project is registered then it" do
      
      before(:each) do
        @meta_survey = Factory(:meta_survey, :organization => @organization)
        visit manager_root_path
      end
      
      it "should be listed" do
        
        common_contents_for(@organization, @manager)

        page.should have_content(@meta_survey.name)
        page.should have_content(@meta_survey.size)
        page.should have_content(@meta_survey.surveys.count)
        page.should have_content(@meta_survey.created_at.to_s(:long))
        
        find_link I18n.t('organization.views.index.download.link')
      end
      
      it "should show me xls and csv formats for exporting the collected results", :js => true do
        
        click_link I18n.t('organization.views.index.download.link')

        page.should have_content I18n.t('organization.views.index.download.dialog_title')
        
        page.should have_content I18n.t('organization.views.index.download.dialog_message')
        find_link I18n.t('organization.views.index.download.formats.xls')
        find_link I18n.t('organization.views.index.download.formats.csv')
      end
    end
  end
end

def common_contents_for(organization, manager)
  current_path.should == manager_root_path
  
  within('#header') do
    page.has_css?('.image').should be_true
    page.should have_content organization.name
    page.should have_content manager.full_name
    
    find_link I18n.t('users.views.index.close_session')
    find_link I18n.t('users.views.index.profile')
  end
  
  within('#notifications') do
    page.should have_content I18n.t('general.messages.welcome')
  end
  
  within('#content') do
    find_link I18n.t('organization.views.index.new_project')
  end
  
  within('#footer') do
    find_link I18n.t('organization.views.index.contact')
  end
end