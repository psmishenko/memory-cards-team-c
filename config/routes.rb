# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: "registrations" }
  devise_scope :user do 
    get 'users/edit_password', to: 'registrations#edit_password'
    patch '/users/edit_password', to: 'registrations#update_password'
  end
  root 'static_pages#home'
  get '/manual', to: 'static_pages#manual'
  resources :boards do
    resources :cards
  end
  get '/404', to: "errors#not_found"
  get '/422', to: "errors#unacceptable"
  get '/500', to: "errors#internal_error"
end
