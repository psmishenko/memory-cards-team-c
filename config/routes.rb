# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    devise_for :users, controllers: { registrations: "registrations"}, skip: :omniauth_callbacks
    resource :user, only: [:edit, :update]
    root 'static_pages#home'
    get '/manual', to: 'static_pages#manual'
    put "remove_avatar", to: "users#remove_avatar"
    resources :boards do
      resources :cards do
        patch :set_confidence_level
      end
      get '/learning', to: 'cards#learning'
    end
    resources :imports, param: :id do
      member do 
       get '/card_import', to: 'imports#card_import'
      end
    end
    get '/404', to: "errors#not_found"
    get '/422', to: "errors#unacceptable"
    get '/500', to: "errors#internal_error"
  end
end
