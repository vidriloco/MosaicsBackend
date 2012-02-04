class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :meta_answer_item
  belongs_to :meta_answer_option
  
  
  def self.build_from(answers, meta_question)
    collected = Array.new
    
    if answers.is_a?(Hash)
      answers.each_pair do |answer_item, option_values|
        if MetaAnswerItem.exists?(answer_item.to_i)
          option_values.each do |option_value|
            if !self.corresponds_to_open_value_question?(meta_question)
              if MetaAnswerOption.exists?(option_value)
                collected << Answer.new(:meta_answer_option_id => option_value, :meta_answer_item_id => answer_item)
              end
            else
              collected << Answer.new(:open_value => option_value, :meta_answer_item_id => answer_item)
            end 
          end
        end
      end  
    else
      if self.corresponds_to_binary_value_question?(meta_question)
        collected << Answer.new(:meta_answer_item_id => answers)
      end
    end
    collected
  end
  
  def self.corresponds_to_open_value_question?(meta_question)
    MetaQuestion.find(:first, :conditions => [ "type_of IN (?) AND id = ?", Quantus.open_question_types, meta_question])
  end
  
  def self.corresponds_to_binary_value_question?(meta_question)
    MetaQuestion.find(:first, :conditions => [ "type_of IN (?) AND id = ?", Quantus.binary_question_types, meta_question])
  end
end
