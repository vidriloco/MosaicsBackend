module Results::Surveys
  
  def collect_results(opts={})
    survey= opts[:with_survey_data] ? {:pollster => pollster.id, :survey => id} : {}
    survey=questions.each.inject(survey) do |collected, question|
      if opts[:with_statistics]
        collected.merge!(question.meta_question.id => question.statistics)
      else
        collected.merge!(question.meta_question.id => question.collect_answers)
      end
      collected
    end
  end
end