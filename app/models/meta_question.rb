class MetaQuestion < ActiveRecord::Base
  has_many :meta_answer_options, :dependent => :destroy
  has_many :meta_answer_items, :dependent => :destroy
  has_many :questions
  belongs_to :meta_survey
  
  def self.register_with(fields, items, options)
    ms=self.new(fields)
    ms.merge_items_and_options(items, options)
    ms
  end
  
  def merge_items_and_options(items, options)
    self.merge_items(items) unless items.nil?
    self.merge_options(options) unless options.nil?
  end
  
  def collect_answers(opts=nil)
    answers = translate_representation
    return answers if opts.nil?
    
    if opts[:report_statistics]
      stats = {}
      answers.each_pair do |key, answers|
        answers.each do |answer|
          if answer.has_key?(:category)
            stats[answer[:item]] ||= 0
            stats[answer[:item]] += 1
          elsif answer.has_key?(:open_value)
            stats[answer[:item]] ||= []
            if question_type.eql?(:perceptual_map)
              stats[answer[:item]] << answer[:open_value].scan(/[-]*[\d.]+/)
            else
              stats[answer[:item]] << answer[:open_value]
            end
          end
        end
      end
      {:answers => stats, :title => title, :total_questions => answers.count}
    end
  end
  
  # Recovers the data of this meta question for postprocessing to plist
  def preprocess_to_plist
    plist_hash = %w(title instruction type_of).each.inject({}) do |last, attr|
      last[attr.to_sym] = self.send(attr)
      last
    end
    
    %w(meta_answer_items meta_answer_options).each do |assoc|
      plist_hash=plist_hash.merge(preprocess_end_chain_with(assoc))
    end
    
    {order_identifier => plist_hash.merge(:meta_question_id => id.to_s)}
  end
  
  # retrieves the question type for this meta_question
  def question_type
    return :perceptual_map if(Quantus.registered_question_types_for(:perceptual_map).include? type_of)
    return :open_value if(Quantus.registered_question_types_for(:open).include? type_of)
  end
  
  protected
  
  # continues execution of tasks for the method: preprocess_to_plist
  def preprocess_end_chain_with(items_or_options)
    preprocessed_chain = self.send(items_or_options).each.inject({}) do |last, item_or_option|
      last[item_or_option.human_value] = { :id => item_or_option.id.to_s, :order_number => item_or_option.identifier }
      last
    end
    {items_or_options.to_sym => preprocessed_chain}
  end
  
  # extracts the structure of the collected questions & answers for this type of meta_question
  def prepare_answer_representation
    equivalence=questions.each.inject({}) do |collected, question| 
      collected.merge!({ question.id => question.answers.map(&:id) })
      collected
    end
    { :mq_id => id, :q_and_a => equivalence }
  end
  
  # translates to human representation
  def translate_representation
    collected = {}
    representation = prepare_answer_representation[:q_and_a]
    representation.keys.map do |question_id|
      representation[question_id].each do |answer_id|
        collected[question_id] ||= []
        collected[question_id] << Answer.generate_result_for(answer_id)
      end
    end
    collected
  end
  
  # builds the response from the client for items
  def merge_items(items)
    items.each_pair do |key, val|
      self.meta_answer_items << MetaAnswerItem.new(:human_value => val["human_value"], :identifier => key)
    end
  end
  
  # builds the response from the client for options
  def merge_options(options)
    options.each_pair do |key, val|
      self.meta_answer_options << MetaAnswerOption.new(:human_value => val["human_value"], :identifier => key)
    end
  end
end
