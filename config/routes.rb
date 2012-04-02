Backend::Application.routes.draw do
  
  devise_for :managers

  devise_for :admin_users do

    namespace :admin do
      get '/' => 'main#index', :as => :index
    
      namespace :meta_surveys do
        get 'new'
      end
      
      get '/meta_surveys' => 'meta_surveys#index'
      post '/meta_surveys' => 'meta_surveys#create'
      get '/meta_surveys/:id.:format' => "meta_surveys#show", :format => "plist", :as => "meta_survey"
    end
  
  end

  namespace :api do
    post :collect
    get :whiteboard, :as => "test_whiteboard"
  end

  post 'api/authenticate.:format' => 'api/sessions#authenticate'
  
  get 'api/survey/:meta_survey_id/results.:format' => "api#results", :as => "download_results"
  
  get "api/evaluation/:meta_survey_id/new" => "api#new", :as => :api_new_survey

  get '/access' => 'welcome#access', :as => :access
  get '/manager' => "manager/main#index", :as => :manager_root
  get '/admin' => "admin/main#index", :as => :admin_user_root

  root :to => 'welcome#index'
end
