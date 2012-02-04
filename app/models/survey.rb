class Survey < ActiveRecord::Base  
  has_many :questions, :dependent => :destroy
  belongs_to :meta_survey
  belongs_to :device
  belongs_to :pollster
  
  def self.from_hash(hash)
    
    question_list = hash.delete("questions")
    
    survey=Survey.new(hash)
    
    question_list.each_key do |meta_question|
      answer_question = question_list[meta_question]
      
      answers = answer_question.delete("answers")
      question = Question.new(answer_question.merge(:meta_question_id => meta_question))
      
      Answer.build_from(answers, meta_question).each { |answer| question.answers << answer }
      
      survey.questions << question
    end
    survey
  end
  
  def self.from_json(json)
    self.from_hash(JSON.parse(json))
  end
end
