class Organization < ActiveRecord::Base
  has_many :managers
  has_many :admin_users
  has_many :campaigns, :dependent => :destroy
  
  def general_managers
    managers.where('campaign_id IS NULL')
  end
end
