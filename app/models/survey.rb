class Survey < ActiveRecord::Base  
  has_many :questions, :dependent => :destroy
  belongs_to :meta_survey
  belongs_to :device
  belongs_to :pollster
  
  def self.from_json(json)
    hash = JSON.parse(json)
    questions = hash.delete("questions")
    survey=Survey.new(hash)
    
    questions.each_pair do |meta_question, answerQuestion|
      answers = answerQuestion.delete("answers")
      
      question = Question.new(answerQuestion.merge(:meta_question_id => meta_question))
      
      Answer.build_from(answers).each { |answer| question.answers << answer }
      
      survey.questions << question
    end
        
    survey
  end
end
