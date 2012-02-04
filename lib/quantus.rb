module Quantus
  #
  # Here we set the identifiers for meta questions with open answers as used in YML descriptor files 
  # or internally in the application meta questions representations
  #
  @@question_types =  {:open => [], :binary => ["SC"] }
  @@authenticity_application_path_ref = nil
  
  # Example: 
  # Quantus.setup do |config|
  #
  #   config.open_question_types = ["MOQ", "OQ"]
  #
  # end
  def self.setup
    yield self
  end
  
  def self.open_question_types=(question_types)
    @@question_types[:open] = question_types
  end
  
  def self.open_question_types
    return @@question_types[:open]
  end
  
  def self.binary_question_types=(question_types)
    @@question_types[:binary] = question_types
  end
  
  def self.binary_question_types
    return @@question_types[:binary]
  end
  
  def self.authenticity_application_path
    return @@authenticity_application_path_ref
  end
  
  def self.authenticity_application_path=(path)
    @@authenticity_application_path_ref = path
  end
  
end