# encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Semantic Differential questions display:" do
  
  describe "Having loaded the survey it" do
  
    before(:each) do
      @admin = Factory(:admin_user)
      @organization = Factory(:organization)
      
      login_with(@admin, new_admin_user_session_path)
      click_link MetaSurvey.model_name.human
      click_link I18n.t('general.actions.new')
      select(@organization.name, :from => "organization")
      path = File.join(Rails.root, "spec", "resources", "surveys", "talleres.yml")
      attach_file("descriptor_file", path)
      click_on I18n.t('general.actions.save')
    end
  
=begin    
    it "should show the evaluation form when visiting it", :js => true do
      visit api_test_whiteboard_path
      
      page.execute_script("remoteMetaSurveyId = #{MetaSurvey.first.id};")
      page.execute_script("loadRemoteMetaSurvey();")

      meta_survey_view(MetaSurvey.first)
    end
    
    it "should allow me to answer the evaluation form", :js => true do
      visit api_test_whiteboard_path
      
      page.execute_script("remoteMetaSurveyId = #{MetaSurvey.first.id};")
      page.execute_script("loadRemoteMetaSurvey();")
      
      
    end
=end
  end
  
  def meta_survey_view(meta_survey)
    within("#meta-survey-#{meta_survey.id}") do
      meta_survey.meta_questions.each do |meta_question|
        meta_question_component(meta_question)
      end
    end
  end
  
  def meta_question_component(meta_question)
    within("#meta-question-#{meta_question.id}") do
      within(".number") do
        page.should have_content meta_question.order_identifier
      end
      
      within(".title") do
        page.should have_content meta_question.title
      end
      
      meta_question.meta_answer_items.each do |meta_answer_item|
        meta_answer_item_component(meta_answer_item)
      end
    end
  end
  
  def meta_answer_item_component(meta_answer_item) 
    within(".options") do
      within("#meta-answer-item-#{meta_answer_item.id}") do
        
        within(".value") do
          page.should have_content meta_answer_item.human_value
        end
      end
    end
  end
end