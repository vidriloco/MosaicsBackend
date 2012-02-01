require 'spec_helper'

describe Survey do
  
  before(:each) do
    @meta_survey = Factory.build(:meta_survey)
    @meta_survey.merge_descriptor_from File.open(File.join(Rails.root, "spec", "resources", "surveys", "survey.yml"))
    @meta_survey.save
    @pollster = Factory(:pollster)
    @device = Factory(:device)
    
    @meta_questions = @meta_survey.meta_questions
  end
  
  describe "Given a survey with two questions has been pushed" do
    
    before(:each) do
      #first
      @f_options = @meta_questions[0].meta_answer_options
      @f_items = @meta_questions[0].meta_answer_items
      
      #second
      @s_options = @meta_questions[4].meta_answer_options
      @s_items = @meta_questions[4].meta_answer_items
      
      a1 = "{\"#{@f_items[0].id}\":[\"#{@f_options[0].id}\", \"#{@f_options[1].id}\"], \"#{@f_items[1].id}\":[\"#{@f_options[1].id}\"]}"
      q1 = "\"#{@meta_questions[0].id}\":{\"start_time\":\"Dec 29, 2011 16:39\",\"end_time\": \"Dec 29, 2011 16:40\",\"answers\":#{a1}}"
      a2 = "{\"#{@s_items[0].id}\":[\"#{@s_options[0].id}\"], \"#{@s_items[1].id}\":[\"#{@s_options[1].id}\"]}"
      q2 = "\"#{@meta_questions[4].id}\":{\"end_time\":\"Dec 30, 2011 16:34\",\"answers\": #{a2},\"start_time\":\"Dec 30, 2011 16:31\"}"
      @json = "{\"meta_survey_id\":\"#{@meta_survey.id}\", \"pollster_id\": \"#{@pollster.id}\", \"device_id\": \"#{@device.id}\", \"questions\": {#{q1}, #{q2}}}"
      
      @survey = Survey.from_json(@json)
    end
    
    it "should persist the survey metadata together with the answers for the first question" do
      survey_meta_question = @survey.questions.first.meta_question
      survey_first_answer = @survey.questions.first.answers[0]
      survey_second_answer = @survey.questions.first.answers[1]
      survey_third_answer = @survey.questions.first.answers[2]
      
      @survey.pollster.should == @pollster
      @survey.device.should == @device
      
      @survey.meta_survey.should == @meta_survey
      @survey.questions.size.should == 2
      @survey.questions.first.start_time.should == Time.parse("Dec 29, 2011 16:39").to_s(:db)
      @survey.questions.first.end_time.should == Time.parse("Dec 29, 2011 16:40").to_s(:db)
      survey_meta_question.should == @meta_questions.first
      
      # For every answer JSON dictionary received the number of records in the database follow the rule: #keys x #items_in_value
      # { key: [val1, val2] } => 2 records on the answers table 
      @survey.questions.first.answers.size.should == 3
      survey_first_answer.meta_answer_item.should == @f_items[0]
      survey_first_answer.meta_answer_option.should == @f_options[0]
      survey_second_answer.meta_answer_item.should == @f_items[0]
      survey_second_answer.meta_answer_option.should == @f_options[1]
      
      survey_third_answer.meta_answer_item.should == @f_items[1]
      survey_third_answer.meta_answer_option.should == @f_options[1]
      
    end
    
    it "should persist the survey metadata together with the answers for the second question" do
      survey_meta_question = @survey.questions.last.meta_question
      survey_first_answer = @survey.questions.last.answers[0]
      survey_second_answer = @survey.questions.last.answers[1]
      
      @survey.meta_survey.should == @meta_survey
      @survey.questions.size.should == 2
      @survey.questions.last.start_time.should == Time.parse("Dec 30, 2011 16:31").to_s(:db)
      @survey.questions.last.end_time.should == Time.parse("Dec 30, 2011 16:34").to_s(:db)
      survey_meta_question.should == @meta_questions[4]

      @survey.questions.last.answers.size.should == 2
      survey_first_answer.meta_answer_item.should == @s_items[0]
      survey_first_answer.meta_answer_option.should == @s_options[0]
      survey_second_answer.meta_answer_item.should == @s_items[1]
      survey_second_answer.meta_answer_option.should == @s_options[1]
      
    end
  end
  
end