class MetaQuestion < ActiveRecord::Base
  include Exports::MetaQuestions
  include Results::MetaQuestions
  
  has_many :meta_answer_options, :dependent => :destroy
  has_many :meta_answer_items, :dependent => :destroy
  has_many :questions
  has_many :answers, :dependent => :destroy
  belongs_to :meta_survey
  
  validates_uniqueness_of :identifier
  
  def self.register_with(fields, items, options)
    ms=self.new(fields)
    ms.merge_items(items) unless items.nil?
    ms.merge_options(options) unless options.nil?
    ms
  end
  
  # retrieves the question type for this meta_question
  def question_type
    return :perceptual_map if(Quantus.registered_question_types_for(:perceptual_map).include? type_of)
    return :open_value if(Quantus.registered_question_types_for(:open).include? type_of)
  end
  
  def with_options_column_components?
    Quantus.question_types_with_components.include? type_of
  end
  
  # builds the response from the client for items
  def merge_items(items)
    items.each_pair do |key, val|
      self.meta_answer_items << MetaAnswerItem.new(:human_value => val["human_value"], :order_identifier => key, :identifier => "#{self.identifier}i#{key}")
    end
  end
  
  # builds the response from the client for options
  def merge_options(options)
    options.each_pair do |key, val|
      self.meta_answer_options << MetaAnswerOption.new(:human_value => val["human_value"], :order_identifier => key, :identifier => "#{self.identifier}o#{key}")
    end
  end
end
