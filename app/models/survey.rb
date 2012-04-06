class Survey < ActiveRecord::Base  
  include Results::Surveys
  include Commits::Surveys
  has_many :questions, :dependent => :destroy
  belongs_to :meta_survey
  belongs_to :device
  belongs_to :pollster
  
  
  # Probably the following methods will be DELETED
  def humanized_columns(conditions={})
    keyed_columns=keyed_columns(conditions)
    keyed_columns.map { |column| Survey.humanize_column_key(column) }
  end
  
  def self.humanize_column_key(column_key_str)
    meta_question, meta_answer_item, meta_answer_option = Survey.column_components(column_key_str)
    
    component="#{meta_question.order_identifier}-#{meta_question.group}-#{meta_answer_item.human_value}"
    component += "-#{meta_answer_option.human_value}" unless(meta_answer_option.nil?)    
  end
  
  def self.column_components(column_key_str)
    components = column_key_str.split("-")
    model_components = [MetaQuestion.find(components[0]), MetaAnswerItem.find(components[1])]
    model_components << MetaAnswerOption.find(components[2]) if(components.size == 3)
  end
  
  def keyed_columns(conditions={})
    keyed_results=[]
    
    meta_survey.meta_questions.where(conditions).each do |meta_question|
      mais = meta_question.meta_answer_items
      maos = meta_question.meta_answer_options
      
      mais.each do |mai|
        keyed_results << "#{meta_question.id}-#{mai.id}" if(maos.empty?)
        maos.each do |mao|
          keyed_results << "#{meta_question.id}-#{mai.id}-#{mao.id}"
        end
      end
    end
    
    keyed_results
  end
end
