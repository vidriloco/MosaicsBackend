module Results::Answers
  
  # Generates the humanized results for this answer
  def generate_results
    return { :item => humanized_item, :category => humanized_option } if has_humanized_option?
    
    if question.meta_question.question_type.eql?(:perceptual_map)
      { :item => humanized_item, :open_value => open_value.scan(/[-]*[\d.]+/) }
    else
      { :item => humanized_item, :open_value => open_value}
    end
  end
  
  def humanized_item
    meta_answer_item.human_value
  end
  
  def has_humanized_option?
    !meta_answer_option.nil?
  end
  
  def humanized_option
    meta_answer_option.human_value
  end
  
end