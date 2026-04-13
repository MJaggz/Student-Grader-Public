Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :users, only: [:index, :destroy] do
    member do
      patch :approve
    end
  end

  post 'courses/reload', to: 'courses#reload', as: :reload_courses
  delete 'courses/destroy_all', to: 'courses#destroy_all', as: :destroy_all_courses
  get 'courses/configuration', to: 'courses#configuration', as: :configuration_courses

  resources :courses do
    resources :sections, only: [:index]
  end

  resources :sections, only: [:show, :destroy] do
    resource :grader_request, only: [:create]
  end

  resources :grader_requests, only: [:index, :show] do
    resources :grader_assignments, only: [:index, :create, :destroy]
  end

  resource :grader_application, only: [:show, :new, :create, :edit, :update]
  get "notifications", to: "notifications#index"
  get "up" => "rails/health#show", as: :rails_health_check
end