Backend::Application.routes.draw do
  
  devise_for :admin_users
  resources :admin_users
  
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
  
  devise_for :managers
  
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
