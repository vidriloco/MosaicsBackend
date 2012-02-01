# encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Management of meta surveys:" do
  
  describe "Having logged-in" do
    
    before(:each) do
      @admin = Factory(:admin_user)
      login_with(@admin, new_admin_user_session_path)
    end

    describe "having an organization registered" do
    
      before(:each) do
        @organization = Factory(:organization)
      end
    
      scenario "should let me add a new meta-survey" do
        click_link MetaSurvey.model_name.human
        current_path.should == admin_meta_surveys_path
      
        page.should have_content("#{I18n.t('general.sections.listing')} #{MetaSurvey.model_name.human.pluralize}")
        page.should have_content I18n.t('meta_survey.views.index.empty')
      
        click_link I18n.t('general.actions.new')
        page.should have_content I18n.t('meta_survey.views.new.title')
        current_path.should == admin_meta_surveys_new_path
      
        select(@organization.name, :from => "organization")
        path = File.join(Rails.root, "spec", "resources", "surveys", "survey.yml")
        attach_file("descriptor_file", path)
        click_on I18n.t('general.actions.save')
      
        current_path.should == admin_meta_surveys_path
              
        within("##{MetaSurvey.first.id}-ms") do
          page.should have_content I18n.t('meta_survey.views.show.fields.organization')
          page.should have_content(@organization.name)
      
          page.should have_content("Encuesta Diversa")
      
          page.should have_content I18n.t('meta_survey.views.show.fields.size')
          page.should have_content(200)
      
          page.should have_content I18n.t('meta_survey.views.show.fields.number_of_questions')
          page.should have_content(11)
      
          find_link I18n.t('general.actions.show_questions')
        end
      end
    end
  end
    
end