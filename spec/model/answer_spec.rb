require 'spec_helper'

describe Answer do
  
  before(:each) do
    @meta_survey = Factory.build(:meta_survey)
    @meta_survey.merge_descriptor_from File.open(File.join(Rails.root, "spec", "resources", "surveys", "survey.yml"))
    @meta_survey.save
    
  end
  
  it "should correctly parse an answer for a multiple option question" do
    mai = @meta_survey.meta_questions[0].meta_answer_items
    mao = @meta_survey.meta_questions[0].meta_answer_options
    answers = {mai[0].id => [mao[0].id, mao[1].id], mai[1].id => [mao[1].id]}
    
    loaded_answers=Answer.build_from(answers, @meta_survey.meta_questions[0].id)
    
    loaded_answers.size.should == 3
    loaded_answers[0].meta_answer_item.should == mai[0]
    loaded_answers[0].meta_answer_option.should == mao[0]
    
    loaded_answers[1].meta_answer_item.should == mai[0]
    loaded_answers[1].meta_answer_option.should == mao[1]
    
    loaded_answers[2].meta_answer_item.should == mai[1]
    loaded_answers[2].meta_answer_option.should == mao[1]
  end
  
  it "should correctly parse an answer for a binary question" do
    mai = @meta_survey.meta_questions[1].meta_answer_items
    mao = @meta_survey.meta_questions[1].meta_answer_options
    answers = {mai[0].id => ["10.32"], mai[1].id => ["49.01"], mai[2].id => ["32.55"], mai[3].id => ["12.99"]}
    
    loaded_answers=Answer.build_from(answers, @meta_survey.meta_questions[1].id)

    loaded_answers.size.should == 4
    loaded_answers[0].meta_answer_item.should == mai[0]
    loaded_answers[0].open_value.should == "10.32"
    loaded_answers[1].meta_answer_item.should == mai[1]
    loaded_answers[1].open_value.should == "49.01"
    loaded_answers[2].meta_answer_item.should == mai[2]
    loaded_answers[2].open_value.should == "32.55"
    loaded_answers[3].meta_answer_item.should == mai[3]
    loaded_answers[3].open_value.should == "12.99"
    
  end
  
end