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

  describe "having loaded the answers definitions from survey.yml" do
    
    before(:each) do
      @survey = Survey.create(:meta_survey_id => @meta_survey.id)
    end
    
    describe "for question 1" do
    
      it "should retrieve it's main column components" do
        keyed_columns = Survey.first.keyed_columns(:order_identifier => 1)
        keyed_columns.size.should == 12
        table_columns = Survey.first.humanized_columns(:order_identifier => 1)
        table_columns.should include("1-Comida Rapida-Burger King-Delicioso")
        table_columns.should include("1-Comida Rapida-Burger King-Saludable")
        table_columns.should include("1-Comida Rapida-Subway-Completo")
        table_columns.should include("1-Comida Rapida-Domino's Pizza-Delicioso")
      end
    
      describe "with mocked answers" do
        
        before(:each) do
          @answers = [mock_answer_for(1, @survey), mock_answer_for(1, @survey), mock_answer_for(1, @survey)].each.inject({}) do |collected, last|
            collected.merge! last
            collected
          end
        end
        
        # {"10592-22837-7" => [set, no set, set ... ]}
        it "should retrieve it's results" do
          expected = {}
          keyed_columns = Survey.first.keyed_columns(:order_identifier => 1)
          keyed_columns.each do |key_col|
            key_column = Survey.humanize_column_key(key_col)
            expected[key_column] ||= []
            @answers.each_pair do |key, val|
              answer = Answer.find_by_column_components(key, Survey.column_components(key_col))
              expected[key_column] << (answer.nil? ? 0 : 1)
            end
          end
        end
       
      end
    
    end
  end
  
end

def mock_answer_for(question_number, survey)
  answers_created=[]
  meta_question=MetaQuestion.first(:conditions => {:order_identifier => question_number})
  meta_answer_items = meta_question.meta_answer_items
  meta_answer_options = meta_question.meta_answer_options
  
  question=Question.create(:survey_id => survey.id, :meta_question_id => meta_question.id)
    
  mao = {}
  meta_answer_items.each do |mai|
    unless meta_answer_options.empty?
      meta_answer_options.sort_by! { rand } 
      mao = {:meta_answer_option_id => meta_answer_options[0].id}
    end
    
    answer = Answer.create(mao.merge(:question_id => question.id, :meta_answer_item_id => mai.id))
    answers_created << answer.id
  end  
  
  {question.id => answers_created}
end