require "spec_helper"

describe ApiController do
  
  describe "routing" do
    
    it "should match /api/collect" do
      { :post => "/api/collect" }.should route_to(:controller => "api", :action => "collect")
    end

    it "should match /api/whiteboard" do
      { :get => "/api/whiteboard" }.should route_to(:controller => "api", :action => "whiteboard")
    end
    
    it "should match /api/evaluation/1/new" do
      { :get => "/api/evaluation/1/new" }.should route_to(:controller => "api", :action => "new", :meta_survey_id => "1")
    end
  end
  
end