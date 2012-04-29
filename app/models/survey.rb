class Survey < ActiveRecord::Base  
  include Results::Surveys
  include Commits::Surveys
  
  has_many :answers, :dependent => :destroy
  belongs_to :device
  belongs_to :pollster
  belongs_to :meta_survey
end
