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
end