class MetaAnswerOption < ActiveRecord::Base
  has_many :answers
  validates_uniqueness_of :identifier
  belongs_to :meta_question
end
