require "spec_helper"

describe CollectorController do
  
  describe "routing" do
    
    it "should match /collector/commit" do
      { :post => "/collector/commit" }.should route_to(:controller => "collector", :action => "commit")
    end

  end
  
end