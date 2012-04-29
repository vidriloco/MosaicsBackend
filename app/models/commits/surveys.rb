module Commits::Surveys
  
  module ClassMethods
    def build_from_hash(json_params)
      return nil if (pollster=Pollster.find_by_uid(json_params["pollster_uid"])).nil?
      return nil if (device=Device.find_by_identifier(json_params["device_id"])).nil?

      meta_survey = MetaSurvey.find_by_identifier(json_params["meta_survey_id"])
      survey = Survey.create({ :pollster => pollster, :device => device, :meta_survey => meta_survey })
      
      json_params["questions"].each_key do |mq_id|
        meta_question = MetaQuestion.find_by_identifier(mq_id)
        answer_data = json_params["questions"][mq_id]
        question = Question.create(
          :start_time => DateTime.parse(answer_data["start_time"]), 
          :end_time => DateTime.parse(answer_data["end_time"]))        
        Answer.register_answer_group(answer_data["answers"], meta_question, { 
          :meta_survey_id => meta_survey.id,
          :survey_id => survey.id, 
          :question_id => question.id })       
      end
      survey
    end
  
    def build_from_json(json)
      self.build_from_hash(JSON.parse(json)["survey"])
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
end