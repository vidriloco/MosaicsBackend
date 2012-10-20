class Campaign < ActiveRecord::Base
  belongs_to :organization
  
  has_many :managers
  has_many :meta_surveys, :dependent => :destroy
  
  def safe_name
    name.chop! if name.index('#') == name.length-1
    name
  end
end
