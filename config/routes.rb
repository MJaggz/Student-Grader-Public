Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  post "fetch_courses", to: "courses#fetch_courses", as: "fetch_courses"
  delete "destroy_all_courses", to: "courses#destroy_all_courses", as: "destroy_all_courses"

  # RESTful Users Routes
  # 'index' handles viewing the list (GET /users)
  # 'destroy' handles deleting a user (DELETE /users/:id)
  resources :users, only: [:index, :destroy] do
    member do
      patch :approve 
    end
  end

  resources :courses
  resources :sections

  # Health & PWA
  get "up" => "rails/health#show", as: :rails_health_check
end