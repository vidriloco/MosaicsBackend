require 'spec_helper'
require 'survey_helper'
include SurveyHelper

describe Survey do
  
  before(:each) do
    @hashed_results = JSON.parse(survey_results)
    
    @meta_survey = Factory.build(:meta_survey)
    @meta_survey.merge_descriptor_from File.open(File.join(Rails.root, "spec", "resources", "surveys", "survey.yml"))
    @meta_survey.save
  end
  
  describe "Given both pollster uid and device identifier are registered" do
    
    before(:each) do
      @pollster = Factory(:pollster)
      @pollster.update_attribute(:uid, @hashed_results["survey"]["pollster_uid"])
      @device = Factory(:device, :identifier => @hashed_results["survey"]["device_id"])
    end
    
    it "should persist a new survey result" do
      survey=Survey.build_from_json(survey_results)
      survey.should_not be_nil
      survey.pollster.should == @pollster
      survey.device.should == @device
      survey.meta_survey.should == @meta_survey
      Question.count.should == @hashed_results["survey"]["questions"].size
    end
    
    describe "and a survey is commited" do
      
      before(:each) do
        Survey.build_from_json(survey_results)
      end
      
      it "should generate the results table for this survey" do
        survey = Survey.first

        survey.bare_results[0].should == {
          :title => I18n.t('surveys.columns.survey.title'),
          :value => survey.id
        }
        
        survey.bare_results[1].should == {
          :title => I18n.t('surveys.columns.pollster.title'),
          :value => @pollster.username
        }
        
        survey.bare_results[2].should == {
          :title => I18n.t('surveys.columns.device.title'),
          :value => @device.identifier
        }
        
        survey.bare_results.should include({
          :title => "P1_1",
          :answer => MetaAnswerOption.find_by_identifier("11o1").order_identifier
        }) 
      
        survey.bare_results.should include({
          :title => "P2_1",
          :answer => MetaAnswerOption.find_by_identifier("12o2").order_identifier
        })
      
        survey.bare_results.should include({
          :title => "P2_2",
          :answer => MetaAnswerOption.find_by_identifier("12o4").order_identifier
        })
      
        survey.bare_results.should include({
          :title => "P2_3",
          :answer => MetaAnswerOption.find_by_identifier("12o5").order_identifier
        })
      
        survey.bare_results.should include({
          :title => "P2_4",
          :answer => MetaAnswerOption.find_by_identifier("12o1").order_identifier
        })
      
        survey.bare_results.should include({
          :title => "P2_5",
          :answer => MetaAnswerOption.find_by_identifier("12o3").order_identifier
        })

        survey.bare_results.should include({
          :title => "P7_1_1",
          :answer => 0.4596774
        })
        
        survey.bare_results.should include({
          :title => "P7_1_2",
          :answer => -0.216129
        })
      
        survey.bare_results.should include({
          :title => "P7_2_1",
          :answer => -0.8709677
        })
        
        survey.bare_results.should include({
          :title => "P7_2_2",
          :answer => -0.8967742
        })
        
        survey.bare_results.should include({
          :title => "P7_3_1",
          :answer => -0.5629032
        })
        
        survey.bare_results.should include({
          :title => "P7_3_2",
          :answer => 0.4693548
        })
      
        survey.bare_results.should include({
          :title => "P7_4_1",
          :answer => 0.5306451
        })
      
        survey.bare_results.should include({
          :title => "P7_4_2",
          :answer => 0.9370968
        })
      
        survey.bare_results.should include({
          :title => "P7_5_1",
          :answer => 0.1387097
        })
        
        survey.bare_results.should include({
          :title => "P7_5_2",
          :answer => -0.6096774
        })
      
        survey.bare_results.should include({
          :title => "P7_6_1",
          :answer => -0.2096774
        })
        
        survey.bare_results.should include({
          :title => "P7_6_2",
          :answer => 0.1532258
        })
      
        survey.bare_results.should include({
          :title => "P7_7_1",
          :answer => -0.533871
        })
        
        survey.bare_results.should include({
          :title => "P7_7_2",
          :answer => -0.5209677
        })
      
        survey.bare_results.should include({
          :title => "P7_8_1",
          :answer => 0.5177419
        })
        
        survey.bare_results.should include({
          :title => "P7_8_2",
          :answer => 0.4693548
        })
      
        survey.bare_results.should include({
          :title => "P3_1",
          :answer => "TGV"
        })
      
        survey.bare_results.should include({
          :title => "P3_2",
          :answer => "SNFC"
        })
        
        survey.bare_results.should include({
          :title => "P3_3",
          :answer => ""
        })
        
        survey.bare_results.should include({
          :title => "P3_4",
          :answer => ""
        })
        
        survey.bare_results.should include({
          :title => "P3_5",
          :answer => ""
        })
        
      end
      
      it "should generate translated results for this survey" do
        survey = Survey.first
        
        survey.bare_results(:translated).should include({
          :title => "P8_1",
          :answer => 4
        })
        
        survey.bare_results(:translated).should include({
          :title => "P8_2",
          :answer => 1
        })
      
        survey.bare_results(:translated).should include({
          :title => "P8_3",
          :answer => 5
        })
      
        survey.bare_results(:translated).should include({
          :title => "P8_4",
          :answer => 2
        })
      
        survey.bare_results(:translated).should include({
          :title => "P8_5",
          :answer => 5
        })
        
        
        survey.bare_results(:translated).should include({
          :title => "P7_1_1",
          :answer => 4
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_1_2",
          :answer => 2
        })
      
        survey.bare_results(:translated).should include({
          :title => "P7_2_1",
          :answer => 1
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_2_2",
          :answer => 1
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_3_1",
          :answer => 2
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_3_2",
          :answer => 4
        })
      
        survey.bare_results(:translated).should include({
          :title => "P7_4_1",
          :answer => 4
        })
      
        survey.bare_results(:translated).should include({
          :title => "P7_4_2",
          :answer => 5
        })
      
        survey.bare_results(:translated).should include({
          :title => "P7_5_1",
          :answer => 3
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_5_2",
          :answer => 1
        })
      
        survey.bare_results(:translated).should include({
          :title => "P7_6_1",
          :answer => 2
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_6_2",
          :answer => 3
        })
      
        survey.bare_results(:translated).should include({
          :title => "P7_7_1",
          :answer => 2
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_7_2",
          :answer => 2
        })
      
        survey.bare_results(:translated).should include({
          :title => "P7_8_1",
          :answer => 4
        })
        
        survey.bare_results(:translated).should include({
          :title => "P7_8_2",
          :answer => 4
        })
        
        
        survey.bare_results(:translated).should include({
          :title => "P9_1_1",
          :answer => 1
        })
        
        survey.bare_results(:translated).should include({
          :title => "P9_1_2",
          :answer => 1
        })
      
        survey.bare_results(:translated).should include({
          :title => "P9_1_3",
          :answer => 2
        })
        
        survey.bare_results(:translated).should include({
          :title => "P9_1_4",
          :answer => 1
        })
      
        survey.bare_results(:translated).should include({
          :title => "P9_2_1",
          :answer => 1
        })
      
        survey.bare_results(:translated).should include({
          :title => "P9_2_2",
          :answer => 1
        })
        
        survey.bare_results(:translated).should include({
          :title => "P9_2_3",
          :answer => 2
        })
        
        survey.bare_results(:translated).should include({
          :title => "P9_2_4",
          :answer => 2
        })

        # "112i2":["-2"],"112i5":["3"],"112i1":["-3"],"112i4":["1"],"112i3":["0"],"112i6":["-1"]}},"
        survey.bare_results(:translated).should include({
          :title => "P12_1",
          :answer => 0
        })
        
        survey.bare_results(:translated).should include({
          :title => "P12_2",
          :answer => 1
        })
      
        survey.bare_results(:translated).should include({
          :title => "P12_3",
          :answer => 3
        })
        
        survey.bare_results(:translated).should include({
          :title => "P12_4",
          :answer => 4
        })
      
        survey.bare_results(:translated).should include({
          :title => "P12_5",
          :answer => 6
        })
        
      end
      
    end
        
  end
  
  describe "Given only the device identifier was provided" do
  
    before(:each) do
      @device = Factory(:device, :identifier => @hashed_results["survey"]["device_id"])
    end
  
    it "should not persist a survey results when the pollster uid is not provided" do
      Survey.build_from_json(survey_results).should be_nil
    end
  
  end
  
  describe "Given only the pollster uid was provided" do
    
    before(:each) do
      @pollster = Factory(:pollster)
      @pollster.update_attribute(:uid, @hashed_results["survey"]["pollster_uid"])
    end
    
    it "should not persist a survey results when the device identifier is not provided" do
      Survey.build_from_json(survey_results).should be_nil
    end
    
  end
  
end