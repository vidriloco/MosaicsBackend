module Results::MetaSurveys
  require 'csv'
  def surveys_to_csv
    statistics.each do |meta_question| 
      rows={}
      CSV.open("#{MetaQuestion.find(meta_question[0]).group}_total.csv", "w") do |csv|
        csv << meta_question[1].keys
        meta_question[1].each_key do |key|
          value = meta_question[1][key]
          
          if value.is_a?(Array)
            value.each_with_index do |val, idx|
              rows[idx] ||= []
              rows[idx] << val
            end
          else
            rows[1] ||= []
            rows[1] << value
          end
        end
        rows.values.each do |val|
          csv << val
        end
      end
    end
  end
  
  def surveys_to_xls
  end
  
  def statistics
    collected = {}
    surveys.each do |survey|
      survey.collect_results(:with_statistics => true).each do |value|
        meta_question_id = value[0]
        values = value[1]
        collected[meta_question_id] ||= {}
        values.each_pair do |key, value|
          if value.is_a?(String) or value.is_a?(Array)
            collected[meta_question_id][key] ||= [] 
            collected[meta_question_id][key] << value
          else
            collected[meta_question_id][key] ||= 0
            collected[meta_question_id][key] += value
          end
        end
      end
    end  
    collected
  end
  
end