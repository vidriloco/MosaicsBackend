require 'spec_helper'

describe MetaSurvey do
  
  before(:each) do
    @organization = Factory(:organization)
  end
  
  it "should register a new MetaSurvey" do
    file = File.open File.join(Rails.root, "spec", "resources", "surveys", "survey.yml")
    ms = MetaSurvey.register_with(:organization_id => @organization.id, :survey_descriptor_file => file)
    ms.should be_new_record
    ms.name.should == "Encuesta Diversa"
    ms.size.should == 200
    ms.organization.should == @organization
    ms.meta_questions.size.should == 11
  end
  
  it "should transform to plist an existent metasurvey" do
    file = File.open File.join(Rails.root, "spec", "resources", "surveys", "survey.yml")
    ms=MetaSurvey.register_with(:organization_id => @organization.id, :survey_descriptor_file => file)
    ms.save
    first_mq = ms.meta_questions.first
    ninth_mq = ms.meta_questions[9]
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
    pre_processed_plist = ms.preprocess_to_plist
    pre_processed_plist.should include(:meta_survey_id => ms.id)
    pre_processed_plist[:meta_questions].should include(first_mq.preprocess_to_plist)
    pre_processed_plist[:meta_questions].should include(ninth_mq.preprocess_to_plist)
  end


end

