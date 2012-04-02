require "spec_helper"

describe Admin::MainController do
  
  describe "routing" do
    
    it "should match /admin" do
      { :get => "/admin" }.should route_to(:controller => "admin/main", :action => "index")
    end

  end
  
end