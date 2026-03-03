Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  # RESTful Users Routes
  # 'index' handles viewing the list (GET /users)
  # 'destroy' handles deleting a user (DELETE /users/:id)
  resources :users, only: [:index, :destroy] do
    member do
      patch :approve 
    end
  end

  resources :courses, only: [:index]

  # Health & PWA
  get "up" => "rails/health#show", as: :rails_health_check
end