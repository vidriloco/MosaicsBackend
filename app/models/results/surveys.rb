module Results::Surveys
  module ClassMethods
    
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def bare_results(opt=nil)
    collected = []
    self.meta_survey.results_frame.each do |column|
      
      conditions = {
        :meta_question_id => column[:meta_question].id,
        :meta_answer_item_id => column[:meta_answer_item].id,
        :survey_id => self.id
      }
      conditions.merge!({:meta_answer_option_id => column[:meta_answer_option].id}) if column.has_key?(:meta_answer_option)
      answer = Answer.find(:first, :conditions => conditions)
      
      value_for_answer = apply_translation(answer, column[:presence_response]) if opt.eql?(:translated)
      
      if value_for_answer.nil?
        value_for_answer = ""
        
        unless answer.nil?
          if answer.meta_question.question_type.eql?(:open_value) || answer.meta_question.question_type.eql?(:perceptual_map)
            value_for_answer = answer.open_value
          else
            value_for_answer = answer.meta_answer_option.order_identifier
          end
        end
      end
      
      collected << {
        :title => column[:title],
        :answer => value_for_answer
      }
    end
    
    metadata = [
      { :title => I18n.t('surveys.columns.survey.title'), :value => self.id },
      { :title => I18n.t('surveys.columns.pollster.title'), :value => self.pollster.username },
      { :title => I18n.t('surveys.columns.device.title'), :value => self.device.identifier }]
      
    metadata+collected
  end
  
  def apply_translation(answer, presence_response=nil)
    if presence_response
      return Quantus.translator_for("presence")[!answer.nil?]
    elsif !answer.nil? 
      results=Quantus.translator_for(answer.meta_question.type_of)

      if(ranges=results["ranges"])
        ranges.keys.each do |key|
          min=ranges[key]["min"][0]
          max=ranges[key]["max"][0]
          return key if(answer.open_value.to_i.in? (min..max))
        end
      end
    end

    nil
  end
end