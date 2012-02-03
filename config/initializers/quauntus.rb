require Rails.root.join('lib','quantus')

Quantus.setup do |config|
  
  config.open_question_types = ["MOQ", "OQ", "MOSM"]

end