require "spec_helper"

describe Admin::MetaSurveysController do
  
  describe "routing" do
    
    it "should match /admin/meta_surveys" do
      { :get => "/admin/meta_surveys" }.should route_to(:controller => "admin/meta_surveys", :action => "index")
    end
    
    it "should match /admin/meta_surveys/new" do
      { :get => "/admin/meta_surveys/new" }.should route_to(:controller => "admin/meta_surveys", :action => "new")
    end
    
    it "should match /admin/meta_surveys" do
      { :post => "/admin/meta_surveys" }.should route_to(:controller => "admin/meta_surveys", :action => "create")
    end
    
    it "should match /admin/meta_surveys/1.plist" do
      { :get => "/admin/meta_surveys/1.plist"}.should route_to(:controller => "admin/meta_surveys", :action => "show", :format => "plist", :id => "1")
    end

  end
  
end