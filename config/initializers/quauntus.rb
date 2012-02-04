require Rails.root.join('lib','quantus')

Quantus.setup do |config|
  
  config.open_question_types = ["MOQ", "OQ", "MOSM"]
  config.authenticity_application_path = "127.0.0.1:3000"
end