module Commits::Surveys
  
  module ClassMethods
    def from_hash(hash, pollster)
    
      question_list = hash.delete("questions")
    
      survey=Survey.new(hash.merge(:pollster_id => pollster.id))
    
      question_list.each_key do |meta_question|
        answer_question = question_list[meta_question]
      
        answers = answer_question.delete("answers")
        question = Question.new(answer_question.merge(:meta_question_id => meta_question))
      
        Answer.build_from(answers, meta_question).each { |answer| question.answers << answer }
      
        survey.questions << question
      end
      survey
    end
  
    def from_json(json)
      self.from_hash(JSON.parse(json))
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
end