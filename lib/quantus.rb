module Quantus
  #
  # Here we set the identifiers for meta questions with open answers as used in YML descriptor files 
  # or internally in the application meta questions representations
  #
  @@question_types =  {:open => [], :binary => ["SC"], :perceptual_map => [] }
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
  
  def self.register_question_type(type, question_types)
    @@question_types[type.to_sym] = question_types
  end
  
  def self.registered_question_types_for(type)
    return @@question_types[type.to_sym]
  end
  
  def self.authenticity_application_path
    return @@authenticity_application_path_ref
  end
  
  def self.authenticity_application_path=(path)
    @@authenticity_application_path_ref = path
  end
  
end