class Manager < User
  belongs_to :organization
  
  validates_presence_of :organization
end
