#encoding: utf-8

require 'spec_helper'
require 'survey_helper'
include SurveyHelper

describe Answer do
  
  before(:each) do
    @meta_survey = Factory.build(:meta_survey)
    @meta_survey.merge_descriptor_from File.open(File.join(Rails.root, "spec", "resources", "surveys", "survey.yml"))
    @meta_survey.save
    
    @results = JSON.parse(survey_results)
    @pollster = Factory(:pollster)
    @pollster.update_attribute(:uid, @results["survey"]["pollster_uid"])
    @device = Factory(:device, :identifier => @results["survey"]["device_id"])
  end
  
  describe "having uploaded a set of survey answers" do
    
    before(:each) do
      Survey.build_from_hash(@results["survey"])
    end
    
    it "should have persisted an answer for a binary question" do
      survey_question_number="11"
      meta_question = MetaQuestion.find_by_identifier(survey_question_number)

      meta_survey = MetaSurvey.first
      survey = Survey.first
      survey.device.should == @device
      survey.pollster.should == @pollster
      
      spec_for_normal_answer(1,1, { 
        :survey_question_number => survey_question_number,
        :meta_question => meta_question, 
        :meta_survey => meta_survey, 
        :survey => survey })
    end
        
    it "should have persisted answers for a multiple answer options for items question" do
      survey_question_number="12"
      meta_question = MetaQuestion.find_by_identifier(survey_question_number)
      
      survey = Survey.first
      survey.device.should == @device
      survey.pollster.should == @pollster
      meta_survey = MetaSurvey.first
      
      params = {
        :survey_question_number => survey_question_number, 
        :meta_question => meta_question, 
        :meta_survey => meta_survey, 
        :survey => survey}
        
      spec_for_normal_answer(1,2, params)
      spec_for_normal_answer(4,1, params)
      spec_for_normal_answer(2,4, params)
      spec_for_normal_answer(5,3, params)
      spec_for_normal_answer(3,5, params)
    end

    it "should have persisted an open value answer for a question with open answers" do
      
      survey_question_number="110"
      meta_question = MetaQuestion.find_by_identifier(survey_question_number)
      
      survey = Survey.first
      survey.device.should == @device
      survey.pollster.should == @pollster
      meta_survey = MetaSurvey.first
      
      params = {
        :survey_question_number => survey_question_number, 
        :meta_question => meta_question, 
        :meta_survey => meta_survey, 
        :survey => survey}
      
      spec_for_open_answer("A",  "Puede ser una buena idea, aunque dificilmente lo será", params)      
    end
    
    it "should have persisted multiple open value answers for a perception map question" do
      
      survey_question_number="17"
      meta_question = MetaQuestion.find_by_identifier(survey_question_number)
      
      survey = Survey.first
      survey.device.should == @device
      survey.pollster.should == @pollster
      meta_survey = MetaSurvey.first
      
      params = {
        :survey_question_number => survey_question_number, 
        :meta_question => meta_question, 
        :meta_survey => meta_survey, 
        :survey => survey}

      spec_for_open_answer(7,  ["-0.533871","-0.5209677"].to_s, params)
      spec_for_open_answer(4,  ["0.5306451","0.9370968"].to_s, params)
      spec_for_open_answer(1,  ["0.4596774","-0.216129"].to_s, params)
      spec_for_open_answer(8,  ["0.5177419","0.4693548"].to_s, params)
      spec_for_open_answer(5,  ["0.1387097","-0.6096774"].to_s, params)
      spec_for_open_answer(2,  ["-0.8709677","-0.8967742"].to_s, params)
      spec_for_open_answer(6,  ["-0.2096774","0.1532258"].to_s, params)
      spec_for_open_answer(3,  ["-0.5629032","0.4693548"].to_s, params)
    end
    
    it "should have persisted multiple open value answers for a multiple open value question" do
      
      survey_question_number="13"
      meta_question = MetaQuestion.find_by_identifier(survey_question_number)
      
      survey = Survey.first
      survey.device.should == @device
      survey.pollster.should == @pollster
      meta_survey = MetaSurvey.first
      
      params = {
        :survey_question_number => survey_question_number, 
        :meta_question => meta_question, 
        :meta_survey => meta_survey, 
        :survey => survey}

      spec_for_open_answer("B",  "SNFC", params)
      spec_for_open_answer("A",  "TGV", params)
    end
    
    it "should have persisted multiple answers with ordering for an ordering question" do
      survey_question_number="16"
      meta_question = MetaQuestion.find_by_identifier(survey_question_number)
      
      survey = Survey.first
      survey.device.should == @device
      survey.pollster.should == @pollster
      meta_survey = MetaSurvey.first
      
      params = {
        :survey_question_number => survey_question_number, 
        :meta_question => meta_question, 
        :meta_survey => meta_survey, 
        :survey => survey}

      spec_for_open_answer(4,  "0", params)
      spec_for_open_answer(2,  "2", params)
      spec_for_open_answer(3,  "1", params)
      spec_for_open_answer(1,  "3", params)
    end

    it "should have persisted multiple answers with percentages for a ponderation question" do
      survey_question_number="18"
      meta_question = MetaQuestion.find_by_identifier(survey_question_number)
      
      survey = Survey.first
      survey.device.should == @device
      survey.pollster.should == @pollster
      meta_survey = MetaSurvey.first
      
      params = {
        :survey_question_number => survey_question_number, 
        :meta_question => meta_question, 
        :meta_survey => meta_survey, 
        :survey => survey}

      spec_for_open_answer(5,  "35", params)
      spec_for_open_answer(3,  "35", params)
      spec_for_open_answer(1,  "25", params)
      spec_for_open_answer(4,  "5", params)
      spec_for_open_answer(2,  "0", params)
    end
    
  end
  
  it "should order a typical array of column names" do
    sorted=["P10_2", "P10_1", "P1_2", "P1_1", "P0_B", "P0_A", "P0_C", "P5_AB", "P5_AC"].sort_as_quantus_header
    sorted.should == ["P0_A", "P0_B", "P0_C", "P1_1", "P1_2", "P5_AB", "P5_AC", "P10_1", "P10_2"]
  end
  
end

def spec_for_open_answer(answer_item_id, open_value, params)
  meta_answer_item = MetaAnswerItem.find_by_identifier("#{params[:survey_question_number]}i#{answer_item_id}")
  
  answer=Answer.find(:first, :conditions => {
    :meta_question_id => params[:meta_question].id,
    :meta_answer_item_id => meta_answer_item.id
  }) 
  
  answer.open_value.should == open_value
  answer.survey.should == params[:survey]
  answer.meta_survey.should == params[:meta_survey]
  answer.question.should_not be_nil
end

def spec_for_normal_answer(answer_item_id, answer_option_id, params)
  meta_answer_item = MetaAnswerItem.find_by_identifier("#{params[:survey_question_number]}i#{answer_item_id}")
  meta_answer_option = MetaAnswerOption.find_by_identifier("#{params[:survey_question_number]}o#{answer_option_id}")
  
  answer=Answer.find(:first, :conditions => {
    :meta_question_id => params[:meta_question].id,
    :meta_answer_option_id => meta_answer_option.id,
    :meta_answer_item_id => meta_answer_item.id
  }) 

  answer.survey.should == params[:survey]
  answer.meta_survey.should == params[:meta_survey]
  answer.question.should_not be_nil
end