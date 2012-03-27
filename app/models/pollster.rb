class Pollster < User
  attr_accessible :birthday, :username
  attr_accessor :login
  devise :authentication_keys => [:login]
  
  before_create :generate_uid
  
  def self.find_for_database_authentication(login)
    where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end
  
  def as_json(opts)
    {
      :uid => uid,
      :username => username || email
    }
  end
  
  def self.digest_survey_from(params)
    if self.find_by_uid(params.delete(:pollster_uid))
      return Survey.from_hash(params)
    end
    return nil
  end
  
  def self.check_credentials(pollster_credentials)
    pollster = self.find_for_database_authentication(pollster_credentials[:username])
    return pollster if pollster.valid_password?(pollster_credentials[:password])
    nil
  end
  
  private
  def generate_uid
    self.uid = Digest::SHA1.hexdigest("#{email}#{Time.now}")
  end
end