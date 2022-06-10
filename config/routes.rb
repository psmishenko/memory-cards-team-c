# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: "registrations" }
  root 'static_pages#home'
  get '/manual', to: 'static_pages#manual'
  resources :boards do
    resources :cards
  end
end
