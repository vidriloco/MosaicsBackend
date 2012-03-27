class MetaSurvey < ActiveRecord::Base
  belongs_to :organization
  
  has_many :meta_questions, :dependent => :destroy
  has_many :surveys, :dependent => :destroy
  
  def self.register_with(params)
    file=params.delete(:survey_descriptor_file)
    meta_survey = MetaSurvey.new(params)
    meta_survey.merge_descriptor_from(file.read)
    meta_survey
  end
  
  def merge_descriptor_from(file_contents)
    contents=Psych.load(file_contents)["survey"]
    self.name=contents["name"]
    self.size=contents["size"]
    self.merge_questions(contents["questions"])
  end
  
  def surveys_to_csv
  end
  
  def surveys_to_xls
  end
  
  
  def transform_to_plist
    preprocess_to_plist.to_plist
  end
  # Plist structure:
  # {:meta_survey_id => 1,
  #  :meta_questions => { 1 (order_identifier) => 
  #                          { :meta_question_id => "3838"
  #                            :title => "Alguna pregunta",
  #                            :meta_answer_options => {1 (id) => {:human_value => "opcion1", identifier => "1"}, 2 => {:human_value => "opcion2", identifier => "2"}},
  #                            :meta_answer_items => {1 (id) => {:human_value => "opcion1", identifier => "1"}, 2 => {:human_value => "opcion2", identifier => "2"}}
  #                          }
  #                    }
  #                 }
  def preprocess_to_plist
    preprocessed = {:meta_survey_id => id.to_s, :meta_questions => {}}
    
    meta_questions.each do |mq|
      preprocessed[:meta_questions].merge!(mq.preprocess_to_plist)
    end
    preprocessed
  end
  
  protected
  def merge_questions(questions)
    questions.each do |q|
      main_fields = {:order_identifier => q[0], :title => q[1]["title"], :type_of => q[1]["type"], :group => q[1]["group"]}
      main_fields[:instruction] = q[1]["instruction"] if q[1].has_key? "instruction"
      meta_question = MetaQuestion.register_with(main_fields, q[1]["items"], q[1]["options"])
      self.meta_questions << meta_question
    end
  end
end
