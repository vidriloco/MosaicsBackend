module Exports::MetaQuestions
  
  # Recovers the data of this meta question for postprocessing to plist
  def preprocess_to_plist
    plist_hash = %w(title instruction type_of).each.inject({}) do |last, attr|
      last[attr.to_sym] = self.send(attr)
      last
    end
    
    %w(meta_answer_items meta_answer_options).each do |assoc|
      plist_hash=plist_hash.merge(preprocess_end_chain_with(assoc))
    end
    
    {order_identifier => plist_hash.merge(:meta_question_id => identifier.to_s)}
  end
  
  protected
  # continues execution of tasks for the method: preprocess_to_plist
  def preprocess_end_chain_with(items_or_options)
    preprocessed_chain = self.send(items_or_options).each.inject({}) do |last, item_or_option|
      last[item_or_option.human_value] = { :id => item_or_option.identifier.to_s, :order_number => item_or_option.order_identifier }
      last
    end
    {items_or_options.to_sym => preprocessed_chain}
  end
end