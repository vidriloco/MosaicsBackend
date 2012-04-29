class Answer < ActiveRecord::Base
  include Results::Answers
  include Commits::Answers
  
  belongs_to :question
  belongs_to :meta_answer_item
  belongs_to :meta_answer_option
  belongs_to :meta_question
  belongs_to :meta_survey
  belongs_to :survey
end
