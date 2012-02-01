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
  
  protected
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
