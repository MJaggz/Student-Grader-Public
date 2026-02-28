Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  # RESTful Users Routes
  # 'index' handles viewing the list (GET /users)
  # 'destroy' handles deleting a user (DELETE /users/:id)
  resources :users, only: [:index, :destroy] do
    member do
      # 'patch' is used because you are updating a specific user's status
      patch :approve 
    end
  end

  # Health & PWA
  get "up" => "rails/health#show", as: :rails_health_check
end