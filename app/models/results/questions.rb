module Results::Questions
  
  def collect_answers
    answers.each.inject({}) do |collected, answer| 
      collected[id] ||= []
      collected[id] << answer.generate_results
      collected
    end
  end
  
  def statistics
    stats = {}
    values = collect_answers.values[0] || []
    values.each do |answer|
      if answer.has_key?(:category)
        stats[answer[:item]+"-"+answer[:category]] = 1
      elsif answer.has_key?(:open_value)
        stats[answer[:item]] = answer[:open_value]
      end
    end
    stats
  end
  
=begin    answers = translate_representation
    return answers if opts.nil?
    
    if opts[:report_statistics]
      stats = {}
      answers.each_pair do |key, answers|
        answers.each do |answer|
          
        end
      end
      {:answers => stats, :title => title, :total_questions => answers.count}
    end
  end
=end
end