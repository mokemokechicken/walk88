Walk88::Application.routes.draw do
  resources :user_records
  get '/user_records/user/:user_id', :to => 'user_records#index', :as => :user_records_of_user
  post '/user_records/:id/fitbit', :to => 'user_records#sync_fitbit'

  resources :user_settings

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks'}

  devise_scope :user do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  root :to => 'home#index'
  get '/', :to => 'home#index', :as => :sign_in_and_redirect
  get '/', :to => 'home#index', :as => :new_user_registration_url

  get '/login_fitbit', :to => 'fitbit#login', :as => :fitbit_login
  get '/callback/fitbit', :to => 'fitbit#callback'
  get '/fitbit_login_success', :to => 'fitbit#login_success', :as => :fitbit_login_success

  resources :user_statuses, :only => %w(index)
end
