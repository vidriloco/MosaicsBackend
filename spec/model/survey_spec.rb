require 'spec_helper'

describe Survey do
  
  before(:each) do
    @meta_survey = Factory.build(:meta_survey)
    @meta_survey.merge_descriptor_from File.open(File.join(Rails.root, "spec", "resources", "surveys", "survey.yml"))
    @meta_survey.save
    @pollster = Factory(:pollster)
    @device = Factory(:device)
    
    @meta_questions = @meta_survey.meta_questions
    @pre_json = {:meta_survey_id => @meta_survey.id, :pollster_id => @pollster.id, :device_id => @device.id}
  end
  
  describe "Pushing a JSON with a Multiple-Option-Select question" do
    
    before(:each) do
      @options = @meta_questions[0].meta_answer_options
      @items = @meta_questions[0].meta_answer_items

      answers = { @items[0].id => [@options[0].id, @options[1].id], @items[1].id => [@options[1].id]}
      question = {@meta_questions[0].id => {:start_time => "Dec 29, 2011 16:39", :end_time => "Dec 29, 2011 16:40", :answers => answers}} 
      
      @pre_json[:questions] = {}.merge(question)
      @survey = Survey.from_json(@pre_json.to_json)
    end
    
    it "should persist the survey metadata together with it's answers" do
      survey_meta_question = @survey.questions.first.meta_question
      survey_first_answer = @survey.questions.first.answers[0]
      survey_second_answer = @survey.questions.first.answers[1]
      survey_third_answer = @survey.questions.first.answers[2]
      
      @survey.pollster.should == @pollster
      @survey.device.should == @device
      
      @survey.meta_survey.should == @meta_survey
      @survey.questions.size.should == 1
      @survey.questions.first.start_time.should == Time.parse("Dec 29, 2011 16:39").to_s(:db)
      @survey.questions.first.end_time.should == Time.parse("Dec 29, 2011 16:40").to_s(:db)
      survey_meta_question.should == @meta_questions.first
      
      # For every answer JSON dictionary received the number of records in the database follow the rule: #keys x #items_in_value
      # { key: [val1, val2] } => 2 records on the answers table 
      @survey.questions.first.answers.size.should == 3
      survey_first_answer.meta_answer_item.should == @items[0]
      survey_first_answer.meta_answer_option.should == @options[0]
      survey_second_answer.meta_answer_item.should == @items[0]
      survey_second_answer.meta_answer_option.should == @options[1]
      
      survey_third_answer.meta_answer_item.should == @items[1]
      survey_third_answer.meta_answer_option.should == @options[1]
      
    end
  end
  
  describe "Pushing a JSON with a Multiple-Select question" do
    
    before(:each) do
      @options = @meta_questions[0].meta_answer_options
      @items = @meta_questions[0].meta_answer_items
      
      answers = { @items[0].id => [@options[0].id], @items[1].id => [@options[1].id], @items[2].id => [@options[3].id] }
      question = { @meta_questions[4].id => { :end_time => "Dec 30, 2011 16:34", :start_time => "Dec 30, 2011 16:31", :answers => answers } }
      
      @pre_json[:questions] = {}.merge(question)
      @survey = Survey.from_json(@pre_json.to_json)
    end
  
    it "should persist the survey metadata together with it's answers" do
      survey_meta_question = @survey.questions.last.meta_question
      survey_first_answer = @survey.questions.last.answers[0]
      survey_second_answer = @survey.questions.last.answers[1]
      survey_third_answer = @survey.questions.last.answers[2]
      
      @survey.meta_survey.should == @meta_survey
      @survey.questions.size.should == 1
      @survey.questions.last.start_time.should == Time.parse("Dec 30, 2011 16:31").to_s(:db)
      @survey.questions.last.end_time.should == Time.parse("Dec 30, 2011 16:34").to_s(:db)
      survey_meta_question.should == @meta_questions[4]

      @survey.questions.last.answers.size.should == 3
      survey_first_answer.meta_answer_item.should == @items[0]
      survey_first_answer.meta_answer_option.should == @options[0]
      survey_second_answer.meta_answer_item.should == @items[1]
      survey_second_answer.meta_answer_option.should == @options[1]
      survey_third_answer.meta_answer_item.should == @items[2]
      survey_third_answer.meta_answer_option.should == @options[3]
    end
  end
  
  describe "Pushing a JSON with open answers for a question" do
    
    before(:each) do
      @options = @meta_questions[6].meta_answer_options
      @items = @meta_questions[6].meta_answer_items
      
      answers = { @items[0].id => ["SNFC"], @items[1].id => ["RATP"] }
      question = {  @meta_questions[6].id => { :end_time => "Jan 30, 2012 8:34", :start_time => "Jan 30, 2012 8:31", :answers => answers } }
      
      @pre_json[:questions] = {}.merge(question)
      @survey = Survey.from_json(@pre_json.to_json)
    end
    
    it "should persist the survey answers " do
      survey_meta_question = @survey.questions.last.meta_question
      survey_first_answer = @survey.questions.last.answers[0]
      survey_second_answer = @survey.questions.last.answers[1]
      
      @survey.meta_survey.should == @meta_survey
      
      @survey.questions.size.should == 1
      
      @survey.questions.last.start_time.should == Time.parse("Jan 30, 2012 8:31").to_s(:db)
      @survey.questions.last.end_time.should == Time.parse("Jan 30, 2012 8:34").to_s(:db)
      survey_meta_question.should == @meta_questions[6]
      
      @survey.questions.last.answers.size.should == 2
      
      survey_first_answer.open_value.should == "SNFC"
      survey_first_answer.meta_answer_item.should == @items[0]
      
      survey_second_answer.open_value.should == "RATP"
      survey_second_answer.meta_answer_item.should == @items[1]
    end
    
  end
  
end