class Question < ActiveRecord::Base
  include Results::Questions
  
  has_many :answers, :dependent => :destroy
  
  # This class stores the start_time and end_time of each question applied
  # The storage of this two datetime fields is on UTC. Conversion required 
  # according to time-zone 
end
