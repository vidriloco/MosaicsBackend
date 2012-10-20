Backend::Application.routes.draw do
  
  devise_for :admin_users
  devise_for :managers, :controllers => { :sessions => "organizations/sessions" } do
    get 'managers' => 'organizations/dashboard#index'
  end
  
  namespace :admin do
    get '/' => 'main#index', :as => :index
    resources :organizations, :except => [:show]
    resources :devices, :except => [:show]
    resources :meta_surveys, :except => [:edit, :update] do
      member do
        get :download
        post :purge
      end
    end
    
    resources :admin_users
    resources :pollsters
    resources :managers
  end
    
  namespace :api do
    post :collect
    get :whiteboard, :as => "test_whiteboard"
  end

  post 'api/authenticate.:format' => 'api/sessions#authenticate'
  get 'api/survey/:meta_survey_id/results.:format' => "api#results", :as => "download_results"  
  get "api/evaluation/:meta_survey_id/new" => "api#new", :as => :api_new_survey

  namespace :organizations do
    resources :dashboard, :only => [:index]
  end
  
  
  resources :welcome, :only => [:index] do 
    collection do 
      get :access
      get :identity
      get :services
      get :success_cases
      get :blog
      get :contact
      get :careers
    end
  end

  root :to => 'welcome#index'
end
