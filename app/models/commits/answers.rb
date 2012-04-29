module Commits::Answers
  module ClassMethods
    def register_answer_group(answers, meta_question, params)
      params.merge!(:meta_question_id => meta_question.id)
      question_type = meta_question.question_type

      answers.each_pair do |answer_item, option_values|
        if MetaAnswerItem.find_by_identifier(answer_item)
          # differentiate from differential map and other question through types
          if question_type.eql?(:perceptual_map)
            Answer.register_as_perceptual_map(option_values, answer_item, params)
          elsif question_type.eql?(:open_value)
            option_values.each do |option_value|
              Answer.register_as_open_value(option_value, answer_item, params)
            end
          else
            option_values.each do |option_value|
              if meta_answer_option=MetaAnswerOption.find_by_identifier(option_value)
                Answer.register_as_normal(meta_answer_option, answer_item, params) 
              end
            end 
          end
        end
      end  
    end

    def register_as_perceptual_map(options, item, params)
      # the options parameter is of the form [x,y]
      self.register_as_open_value(options.to_s, item, params)
    end

    def register_as_open_value(option, item, params)
      meta_answer_item = MetaAnswerItem.find_by_identifier(item)
      Answer.create(params.merge(:open_value => option, :meta_answer_item_id => meta_answer_item.id))
    end

    def register_as_normal(option, item, params)
      meta_answer_item = MetaAnswerItem.find_by_identifier(item)
      Answer.create(params.merge(:meta_answer_option_id => option.id, :meta_answer_item_id => meta_answer_item.id))
    end

    private
    def get_question_type_for(meta_question_id)
      meta_question=MetaQuestion.find(meta_question_id)
      meta_question.question_type
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
end