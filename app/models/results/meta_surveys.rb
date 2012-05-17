module Results::MetaSurveys
  require 'csv'
  
  def render_as_csv
    CSV.open("Encuesta-#{self.identifier}-resultados.csv", "wb:ISO8859-1") do |csv|
      self.rows_for_csv.each do |row|
        csv << row
      end  
    end
  end
  
  def render_as_csv_string
    CSV.generate do |csv|
      self.rows_for_csv.each do |row|
        csv << row
      end
    end
  end
  
  def results_frame
    collected = []
    self.meta_questions.each do |mq|
      mq.meta_answer_items.each do |mai|
        if mq.with_options_column_components?
          mq.meta_answer_options.each do |mao|
            collected << {
              :title => "P#{mq.order_identifier}_#{mai.order_identifier}_#{mao.order_identifier}",
              :empty_fill => Quantus.fill_empty?(mq.type_of),
              :meta_question => mq,
              :meta_answer_item => mai,
              :meta_answer_option => mao
            }
          end
        else
          collected << {
            :title => "P#{mq.order_identifier}_#{mai.order_identifier}",
            :empty_fill => Quantus.fill_empty?(mq.type_of),
            :meta_question => mq,
            :meta_answer_item => mai
          }
        end        
      end        
    end
    collected
  end
  
  def merged_results(opt=nil)
    results = {}
    
    self.surveys.each do |survey|
      survey.bare_results(opt).each do |result|
        results[result[:title]] ||= []
        # including survey answers
        if result.has_key?(:answer)
          results[result[:title]] << result[:answer]
        # including survey data
        elsif result.has_key?(:value)
          results[result[:title]] << result[:value] 
        end
      end
    end
    results
  end

  def rows_for_csv
    results = self.merged_results(:translated)
    fixed_columns = results.keys[0,3]
    ordered_columns = results.keys[3, results.keys.length].sort_as_quantus_header
    
    rows = [fixed_columns+ordered_columns]
        
    (0..self.surveys.count-1).to_a.each do |index|
      collected = []
      rows[0].each do |key|
        collected << results[key][index]
      end
      rows << collected
    end
   
    rows
  end

end