module Exports::MetaSurveys
  
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
  
end