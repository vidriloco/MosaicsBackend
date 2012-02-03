class Survey < ActiveRecord::Base  
  has_many :questions, :dependent => :destroy
  belongs_to :meta_survey
  belongs_to :device
  belongs_to :pollster
  
  def self.from_json(json)
    hash = JSON.parse(json)
    question_list = hash.delete("questions")
    survey=Survey.new(hash)
    
    question_list.each do |question|
      meta_question = question.keys[0]
      answer_question = question[meta_question]
      
      answers = answer_question.delete("answers")
      question = Question.new(answer_question.merge(:meta_question_id => meta_question))
      
      Answer.build_from(answers, meta_question).each { |answer| question.answers << answer }
      
      survey.questions << question
    end
    survey
  end
end
