class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :meta_answer_item
  belongs_to :meta_answer_option
  
  
  def self.build_from(answers)
    collected = Array.new
    
    answers.each_pair do |answer_item, option_values|
      if MetaAnswerItem.exists?(answer_item.to_i)
        option_values.each do |option_value|
          if !self.has_open_value?(option_value) and MetaAnswerOption.exists?(option_value.to_i)
            collected << Answer.new(:meta_answer_option_id => option_value, :meta_answer_item_id => answer_item)
          else
            #chop the open value flag from value
            option_value[0..1]=""
            collected << Answer.new(:open_value => option_value, :meta_answer_item_id => answer_item)
          end 
        end
      end
    end  

    collected
  end
  
  def self.has_open_value?(option_value)
    option_value[0,2]=="o:" if option_value.is_a? String
  end
end
