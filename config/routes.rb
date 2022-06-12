# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    devise_for :users, controllers: { registrations: "registrations", omniauth_callbacks: "users/omniauth_callbacks" }
    resource :user, only: [:edit, :update]
    root 'static_pages#home'
    get '/manual', to: 'static_pages#manual'
    resources :boards do
      resources :cards
      get '/learning', to: 'cards#learning'
    end
    get '/404', to: "errors#not_found"
    get '/422', to: "errors#unacceptable"
    get '/500', to: "errors#internal_error"
  end
end
