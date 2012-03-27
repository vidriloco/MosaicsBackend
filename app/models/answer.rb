class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :meta_answer_item
  belongs_to :meta_answer_option
  
  
  def self.build_from(answers, meta_question)
    collected = Array.new
    question_type = get_question_type_for(meta_question)
    
    answers.each_pair do |answer_item, option_values|
      if MetaAnswerItem.exists?(answer_item.to_i)
        # differentiate from differential map and other question through types
        if question_type.eql?(:perceptual_map)
          collected << Answer.register_as_perceptual_map(option_values, answer_item)
        else
          option_values.each do |option_value|
            if question_type.eql?(:open_value)
              collected << Answer.register_as_open_value(option_value, answer_item)
            else
              collected << Answer.register_as_normal(option_value, answer_item) if(MetaAnswerOption.exists?(option_value))
            end 
          end
        end
      end
    end  
    collected
  end
  
  def self.find_by_column_components(question_id, components)
    opts = components.size == 3 ? {:meta_answer_option_id => components[2].id} : {}
    self.first(:conditions => opts.merge({ :question_id => question_id, :meta_answer_item_id => components[1].id }))
  end
  
  # Extractor methods
  
  def humanized_item
    meta_answer_item.human_value
  end
  
  def has_humanized_option?
    !meta_answer_option.nil?
  end
  
  def humanized_option
    meta_answer_option.human_value
  end
  
  def self.register_as_perceptual_map(options, item)
    # the options parameter is of the form [x,y]
    self.register_as_open_value(options.to_s, item)
  end
  
  def self.register_as_open_value(option, item)
    Answer.new(:open_value => option, :meta_answer_item_id => item.to_i)
  end
  
  def self.register_as_normal(option, item)
    Answer.new(:meta_answer_option_id => option.to_i, :meta_answer_item_id => item.to_i)
  end
  
  private
  def self.get_question_type_for(meta_question_id)
    meta_question=MetaQuestion.find(meta_question_id)
    meta_question.question_type
  end
end
