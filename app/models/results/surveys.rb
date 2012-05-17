module Results::Surveys
  module ClassMethods
    
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def bare_results(opt=nil)
    collected = []
    self.meta_survey.results_frame.each do |column|
      answer = answer_from_conditions(column)
      question_type = column[:meta_question].question_type
      
      value_for_answer = ""
      unless answer.nil?
        if question_type.eql?(:perceptual_map)
          value_for_answer = column[:title].last == '1' ? eval(answer.open_value)[0].to_f : eval(answer.open_value)[1].to_f
        elsif question_type.eql?(:open_value)
          value_for_answer = answer.open_value
        else
          value_for_answer = answer.meta_answer_option.order_identifier
        end
      end
      
      if opt.eql?(:translated)
        value_for_answer = apply_translation_for(value_for_answer, column[:meta_question].type_of, {:empty_fill => column[:empty_fill] }) 
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
  
  def apply_translation_for(value, question_type, opts={})
    if opts[:empty_fill]
      return Quantus.translator_for("fillable_when_empty")[!value.blank?]
    elsif !value.blank? 
      results=Quantus.translator_for(question_type)
      
      case question_type
      when "CS"
        results = results["translation"]
        results.keys.each do |key|
          min=results[key]["min"][0]
          max=results[key]["max"][0]
          return key if(value.to_i.in? (min..max))
        end
      when "SD", "PO"
        results = results["translation"]
        return value.to_i+results["value"].to_i
      when "MOSM"
        ranges = results["definition"]
        old_range = 2 # 1 - (-1)
        new_range = ranges["max"]-ranges["min"]
        value = (((value+1) * new_range) / old_range) + ranges["min"]
        value = value.round
        
        results = results["translation"]
        results.keys.each do |key|
          min=results[key]["min"][0]
          max=results[key]["max"][0]
          return key if(value <= max && value > min)
        end
      else
        return value
      end
    end

    nil
  end
  
  private
  def answer_from_conditions(column)
    conditions = {
      :meta_question_id => column[:meta_question].id,
      :meta_answer_item_id => column[:meta_answer_item].id,
      :survey_id => self.id
    }
    
    if column.has_key?(:meta_answer_option) && !column[:meta_question].type_of.eql?("MOSM")
      conditions.merge!({:meta_answer_option_id => column[:meta_answer_option].id}) 
    end
    
    Answer.find(:first, :conditions => conditions)
  end
end