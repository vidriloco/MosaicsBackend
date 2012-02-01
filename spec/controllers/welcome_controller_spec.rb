require 'spec_helper'

describe WelcomeController do

  describe "GET index" do
  
    before(:each) do
      @manager = Factory(:manager)
    end
    
    it "should respond with a redirect if I am NOT logged-in" do
      get :index
      response.should be_redirect 
    end
     
    describe "if I am logged-in" do
  
      before(:each) do
        sign_in @manager
      end
  
      it "should set the current manager" do
        get :index 
        assigns(:manager).should == @manager
      end
      
      it "should respond with a success" do
        get :index 
        response.should be_success
      end
    end
  
  end
  
end