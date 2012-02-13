require 'spec_helper'

describe Admin::MetaSurveysController do

  before(:each) do
    @admin = Factory(:admin_user)
  end

  describe "GET show" do
    
    before(:each) do
      @meta_survey = MetaSurvey.new(:name => "Encuestita")
    end
    
    describe "if logged-in" do
      
      before(:each) do
        sign_in @admin
      end
    
      it "should find the meta-survey to get it's meta-data from" do
        MetaSurvey.should_receive(:find).with("1").and_return(@meta_survey)
        @meta_survey.should_receive(:transform_to_plist)
        get :show, :id => "1", :format => "plist"
        assigns(:meta_survey).should == @meta_survey
      end
    end
    
  end

  describe "GET index" do
  
    before(:each) do
      @meta_surveys = []
    end
    
    it "should respond with a redirect if I am NOT logged-in" do
      get :index
      response.should be_redirect 
    end
     
    describe "if I am logged-in" do
  
      before(:each) do
        sign_in @admin
      end
  
      it "should set the current manager" do
        MetaSurvey.should_receive(:all) { @meta_surveys }
        get :index 
        assigns(:meta_surveys).should == @meta_surveys
      end
      
      it "should respond with a success" do
        get :index 
        response.should be_success
      end
    end
  
  end
  
  describe "GET new" do
  
    before(:each) do
      @meta_survey = MetaSurvey.new
    end
    
    it "should respond with a redirect if I am NOT logged-in" do
      get :new
      response.should be_redirect 
    end
     
    describe "if I am logged-in" do
  
      before(:each) do
        sign_in @admin
      end
  
      it "should render a new meta survey form" do
        MetaSurvey.should_receive(:new) { @meta_survey }
        get :new 
        assigns(:meta_survey).should == @meta_survey
      end
      
      it "should respond with a success" do
        get :new 
        response.should be_success
      end
    end
  
  end
  
  describe "POST create" do
  
    before(:each) do
      @meta_survey = MetaSurvey.new
    end
    
    it "should respond with a redirect if I am NOT logged-in" do
      post :create
      response.should be_redirect 
    end
     
    describe "if I am logged-in" do
  
      before(:each) do
        sign_in @admin
      end
    
      describe "with valid parameters" do
        
        before(:each) do
          @meta_survey.stub(:save).and_return(true)
        end
        
        it "should receive the parameters for registering a new meta survey instance" do
          MetaSurvey.should_receive(:register_with).with({ 'with' => 'some params' }) { @meta_survey }
          post :create, :meta_survey => { 'with' => 'some params' }
          assigns(:meta_survey).should == @meta_survey
        end
      
        it "should respond with a redirect" do
          MetaSurvey.stub(:register_with) { @meta_survey }
          post :create, :meta_survey => { }
          response.should be_redirect
        end
      
      end
      
      describe "with NON-valid parameters" do
        
        before(:each) do
          @meta_survey.stub(:save).and_return(false)
        end
      
        it "should render the new template" do
          MetaSurvey.stub(:register_with) { @meta_survey }
          post :create, :meta_survey => { }
          response.should render_template("new")
        end
      
      end
    end
  
  end
  
end