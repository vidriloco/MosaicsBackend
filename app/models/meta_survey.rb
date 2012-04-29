class MetaSurvey < ActiveRecord::Base
  include Results::MetaSurveys
  include Loads::MetaSurveys
  include Exports::MetaSurveys
  
  belongs_to :organization
  
  has_many :meta_questions, :dependent => :destroy
  has_many :surveys, :dependent => :destroy
  has_many :answers, :dependent => :destroy
end
