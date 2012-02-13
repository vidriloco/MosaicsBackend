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
  
  def preprocess_to_plist
    plist_hash = %w(title instruction type_of).each.inject({}) do |last, attr|
      last[attr.to_sym] = self.send(attr)
      last
    end
    
    %w(meta_answer_items meta_answer_options).each do |assoc|
      plist_hash=plist_hash.merge(preprocess_end_chain_with(assoc))
    end
    
    {order_identifier => plist_hash.merge(:meta_question_id => id)}
  end
  
  def prepare_answers_results
    answer_hash={}
    questions.each do |question|
      question.answers.each do |answer|
        answer_hash[answer.meta_answer_item.human_value] ||= {}
        answer_hash[answer.meta_answer_item.human_value][answer.meta_answer_option.human_value] ||= 0

        answer_hash[answer.meta_answer_item.human_value][answer.meta_answer_option.human_value] += 1
      end
    end
    
    {order_identifier => {:title => title, :total => questions.count}.merge(answer_hash)}
  end
  
  protected
  
  def preprocess_end_chain_with(items_or_options)
    preprocessed_chain = self.send(items_or_options).each.inject({}) do |last, item_or_option|
      last[item_or_option.id] = { :human_value => item_or_option.human_value, :identifier => item_or_option.identifier }
      last
    end
    {items_or_options.to_sym => preprocessed_chain}
  end
  
  def merge_items(items)
    items.each_pair do |key, val|
      self.meta_answer_items << MetaAnswerItem.new(:human_value => val["human_value"], :identifier => key)
    end
  end
  
  def merge_options(options)
    options.each_pair do |key, val|
      self.meta_answer_options << MetaAnswerOption.new(:human_value => val["human_value"], :identifier => key)
    end
  end
end
