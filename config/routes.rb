# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  post 'auth/guest', to: 'guest_auth#login'
  resources :requests, only: %i[index show create update destroy]

  # Defines the root path route ("/")
  # root "posts#index"
end
