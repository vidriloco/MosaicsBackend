#encoding: utf-8
require 'spec_helper'

describe MetaQuestion do
  
  it "should register associate answer options and items to a given question" do
    mq = MetaQuestion.new
    
    options = {1=>{"human_value"=>"Burger King"}, 2=>{"human_value"=>"Domino's Pizza"}, 3=>{"human_value"=>"Subway"}}
    items = {"A"=>{"human_value"=>"Delicioso"}, "B"=>{"human_value"=>"Saludable"}, "C"=>{"human_value"=>"Completo"}, "D"=>{"human_value"=>"Económico"}}
    mq.merge_items_and_options(items, options)
    mq.meta_answer_options.length.should == 3
    
    mq.meta_answer_options.first.human_value.should == "Burger King"
    mq.meta_answer_options.first.identifier.should == 1
    
    mq.meta_answer_items.length.should == 4
    
    mq.meta_answer_items.first.human_value.should == "Delicioso"
    mq.meta_answer_items.first.identifier.should == "A"
  end
  
  describe "having a meta-question registered" do
  
    before(:each) do
      @meta_question=MetaQuestion.new(:meta_survey_id => 1, :title => "Un titulo cualquiera", :instruction => "Una instrucción", :type_of => "MAO", :order_identifier => "1")
      @meta_question.meta_answer_options.build(:human_value => "Opción cualquiera", :identifier => "1")
      @meta_question.meta_answer_options.build(:human_value => "Opción alternativa", :identifier => "2")
      @meta_question.meta_answer_items.build(:human_value => "Elemento cualquiera", :identifier => "II")
      @meta_question.save!
    end
  
    it "should render a prepared hash with it's metadata" do    
      @meta_question.preprocess_to_plist.should == {@meta_question.order_identifier => {
        :meta_question_id => @meta_question.id,
        :title => "Un titulo cualquiera", 
        :instruction => "Una instrucción", 
        :type_of => "MAO", 
        :meta_answer_items => {MetaAnswerItem.first.id => {:human_value => "Elemento cualquiera", :identifier => "II"} },
        :meta_answer_options => {MetaAnswerOption.first.id => {:human_value => "Opción cualquiera", :identifier => "1"},
                                 MetaAnswerOption.last.id => {:human_value => "Opción alternativa", :identifier => "2"}}
        }
      }
    end
    
    describe "with two one option answer" do
    
      before(:each) do
        question_answer_one=Question.create(:meta_question => @meta_question, :survey => Survey.new)
        Answer.create(:meta_answer_option => @meta_question.meta_answer_options.first, :meta_answer_item => @meta_question.meta_answer_items.first, :question => question_answer_one)
        
        question_answer_two=Question.create(:meta_question => @meta_question, :survey => Survey.new)
        Answer.create(:meta_answer_option => @meta_question.meta_answer_options.last, :meta_answer_item => @meta_question.meta_answer_items.first, :question => question_answer_two)
        
        question_answer_three=Question.create(:meta_question => @meta_question, :survey => Survey.new)
        Answer.create(:meta_answer_option => @meta_question.meta_answer_options.last, :meta_answer_item => @meta_question.meta_answer_items.first, :question => question_answer_three)
      end
    
      it "should render a prepared hash with it's answer results" do
        @meta_question.prepare_answers_results.should == { 1 => {:title => "Un titulo cualquiera", :total => 3, "Elemento cualquiera" => { "Opción alternativa" => 2, "Opción cualquiera" => 1} }}
      end
    end
  end
end