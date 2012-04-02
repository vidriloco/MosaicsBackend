class Question < ActiveRecord::Base
  include Results::Questions
  
  has_many :answers, :dependent => :destroy
  belongs_to :survey
  belongs_to :meta_question
end
