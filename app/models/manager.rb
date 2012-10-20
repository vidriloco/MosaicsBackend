class Manager < User
  belongs_to :organization
  belongs_to :campaign
  
  validates_presence_of :organization
  
end
