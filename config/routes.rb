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
    end
  
  end

  namespace :api do
    post :collect
    get :whiteboard, :as => "test_whiteboard"
  end
  get "api/evaluation/:meta_survey_id/new" => "api#new", :as => :api_new_survey

  get '/manager' => "welcome#index", :as => :manager_root
  get '/admin' => "admin/main#index", :as => :admin_user_root

  root :to => 'welcome#index'

end
