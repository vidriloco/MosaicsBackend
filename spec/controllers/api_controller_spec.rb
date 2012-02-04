require 'spec_helper'

describe ApiController do

  before(:each) do
    @survey = Factory.build(:survey)
  end

  describe "POST commit: " do
    
    describe "Given the results of a single survey application are pushed" do
      
      it "should assign the new survey to @survey" do
        Survey.should_receive(:from_json).and_return { @survey }
        post :collect, :survey => "a json string"
        assigns(:survey).should == @survey
      end
      
      describe "on successful save" do
        
        before(:each) do
          @survey.stub(:save).and_return(true)
        end
        
        it "should return a success response" do
          Survey.should_receive(:from_json).and_return { @survey }
          post :collect, :survey => "a valid json string"
          response.should be_success
        end
        
      end
      
      describe "on unsuccessful save" do
        
        before(:each) do
          @survey.stub(:save).and_return(false)
        end
        
        it "should return a failure response" do
          Survey.should_receive(:from_json).and_return { @survey }
          post :collect, :survey => "an invalid json string"
          response.should_not be_success
        end
        
      end
      
    end
    
  end
  
  describe "GET new:" do
    
    before(:each) do
      @meta_survey = MetaSurvey.new
    end
    
    it "should find the meta survey to be rendered" do
      MetaSurvey.should_receive(:find).with("1").and_return(@meta_survey)
      get :new, :meta_survey_id => "1"
      assigns(:meta_survey).should == @meta_survey
    end    
    
  end

end