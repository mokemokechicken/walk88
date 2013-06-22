Walk88::Application.routes.draw do
  resources :user_records

  resources :user_settings

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks'}

  devise_scope :user do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  root :to => 'home#index'
  get '/', :to => 'home#index', :as => :sign_in_and_redirect
  get '/', :to => 'home#index', :as => :new_user_registration_url

end
