module Loads::MetaSurveys
  
  module ClassMethods
    def register_with(params, campaign)
      file=params.delete(:survey_descriptor_file)
      
      organization = Organization.find(campaign[:organization_id])
      campaign = Campaign.create(:organization_id => organization.id, :name => "#{campaign[:name]} #{Time.now.to_s(:short)} #")
      meta_survey = MetaSurvey.new(params.merge(:campaign_id => campaign.id))
      meta_survey.save if meta_survey.merge_descriptor_from(file.read)
      meta_survey
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def merge_descriptor_from(file_contents)
    contents=Psych.load(file_contents)["survey"]
    
    self.name=contents["name"]
    self.size=contents["size"]
    
    if MetaSurvey.find_by_identifier(contents["identifier"]).nil?
      self.identifier=contents["identifier"]
      self.merge_questions(contents["questions"])
    else
      self.errors.add(:identifier, I18n.t('meta_survey.validations.identifier'))
      false
    end
  end
  
  protected
  def merge_questions(questions)
    questions.each do |q|
      main_fields = {
        :order_identifier => q[0], 
        :title => q[1]["title"], 
        :type_of => q[1]["type"], 
        :group => q[1]["group"], 
        :identifier => "#{self.identifier}#{q[0]}"}
      main_fields[:instruction] = q[1]["instruction"] if q[1].has_key? "instruction"
      meta_question = MetaQuestion.register_with(main_fields, q[1]["items"], q[1]["options"])
      self.meta_questions << meta_question
    end
  end
  
end