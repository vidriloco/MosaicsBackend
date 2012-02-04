require 'spec_helper'

describe Answer do
  
  before(:each) do
    @meta_survey = Factory.build(:meta_survey)
    @meta_survey.merge_descriptor_from File.open(File.join(Rails.root, "spec", "resources", "surveys", "survey.yml"))
    @meta_survey.save
    
  end
  
  it "should correctly parse an answer for a multiple option question" do
    items = @meta_survey.meta_questions[0].meta_answer_items
    options = @meta_survey.meta_questions[0].meta_answer_options
    answers = {items[0].id => [options[0].id, options[1].id], items[1].id => [options[1].id]}
    
    loaded_answers=Answer.build_from(answers, @meta_survey.meta_questions[0].id)
    
    loaded_answers.size.should == 3
    loaded_answers[0].meta_answer_item.should == items[0]
    loaded_answers[0].meta_answer_option.should == options[0]
    
    loaded_answers[1].meta_answer_item.should == items[0]
    loaded_answers[1].meta_answer_option.should == options[1]
    
    loaded_answers[2].meta_answer_item.should == items[1]
    loaded_answers[2].meta_answer_option.should == options[1]
  end
  
  it "should correctly parse an answer for a binary question" do
    items = @meta_survey.meta_questions[4].meta_answer_items
    options = @meta_survey.meta_questions[4].meta_answer_options
    answers = items[0].id
    
    loaded_answers=Answer.build_from(answers, @meta_survey.meta_questions[4].id)
    loaded_answers.size.should == 1
    loaded_answers[0].meta_answer_item.should == items[0]
    loaded_answers[0].meta_answer_option.should be_nil
  end
  
  it "should correctly parse an answer for an open valued numeric question" do
    items = @meta_survey.meta_questions[1].meta_answer_items
    answers = {items[0].id => ["10.32"], items[1].id => ["49.01"], items[2].id => ["32.55"], items[3].id => ["12.99"]}
    
    loaded_answers=Answer.build_from(answers, @meta_survey.meta_questions[1].id)

    loaded_answers.size.should == 4
    loaded_answers[0].meta_answer_item.should == items[0]
    loaded_answers[0].open_value.should == "10.32"
    loaded_answers[1].meta_answer_item.should == items[1]
    loaded_answers[1].open_value.should == "49.01"
    loaded_answers[2].meta_answer_item.should == items[2]
    loaded_answers[2].open_value.should == "32.55"
    loaded_answers[3].meta_answer_item.should == items[3]
    loaded_answers[3].open_value.should == "12.99"
    
  end
  
end