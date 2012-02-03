module Quantus
  #
  # Here we set the identifiers for meta questions with open answers as used in YML descriptor files 
  # or internally in the application meta questions representations
  #
  @@open_question_types_ref = []


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
    @@open_question_types_ref = question_types
  end
  
  def self.open_question_types
    return @@open_question_types_ref
  end
  
end