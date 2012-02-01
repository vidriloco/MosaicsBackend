class Organization < ActiveRecord::Base
  has_many :managers
  has_many :meta_surveys
end
