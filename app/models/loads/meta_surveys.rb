module Loads::MetaSurveys
  
  def self.register_with(params)
    file=params.delete(:survey_descriptor_file)
    meta_survey = MetaSurvey.new(params)
    meta_survey.merge_descriptor_from(file.read)
    meta_survey
  end
  
  def merge_descriptor_from(file_contents)
    contents=Psych.load(file_contents)["survey"]
    self.name=contents["name"]
    self.size=contents["size"]
    self.merge_questions(contents["questions"])
  end
  
  protected
  def merge_questions(questions)
    questions.each do |q|
      main_fields = {:order_identifier => q[0], :title => q[1]["title"], :type_of => q[1]["type"], :group => q[1]["group"]}
      main_fields[:instruction] = q[1]["instruction"] if q[1].has_key? "instruction"
      meta_question = MetaQuestion.register_with(main_fields, q[1]["items"], q[1]["options"])
      self.meta_questions << meta_question
    end
  end
  
end