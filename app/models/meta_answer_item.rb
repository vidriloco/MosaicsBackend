class MetaAnswerItem < ActiveRecord::Base
  has_many :answers
  belongs_to :meta_question
end
