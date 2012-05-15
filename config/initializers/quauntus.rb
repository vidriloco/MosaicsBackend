require Rails.root.join('lib','quantus')

Quantus.setup do |config|
  
  config.register_question_type(:open, ["OQ", "MOQ", "PO", "CS", "SD"])
  config.register_question_type(:perceptual_map, ["MOSM"])
  config.register_question_types_with_components(["MOS", "MOSM"])
  config.register_questions_for_empty_fill(["MOS", "MSB"])
  config.authenticity_application_path = "127.0.0.1:3000"
  config.load_translators_from = "translators.yml"
end