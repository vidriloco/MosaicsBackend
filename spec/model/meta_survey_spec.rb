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
end

