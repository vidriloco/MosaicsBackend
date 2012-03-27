require Rails.root.join('lib','quantus')

Quantus.setup do |config|
  
  config.register_question_type(:open, ["OQ", "SC", "MOQ", "PO", "CS", "SD"])
  config.register_question_type(:perceptual_map, "MOSM")
  config.authenticity_application_path = "127.0.0.1:3000"
end