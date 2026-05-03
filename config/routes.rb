Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :users, only: [:index, :destroy] do
    member do
      patch :approve
    end
  end

  post 'courses/reload', to: 'courses#reload', as: :reload_courses
  post 'courses/copy_term_setup', to: 'courses#copy_term_setup', as: :copy_term_setup_courses
  delete 'courses/destroy_all', to: 'courses#destroy_all', as: :destroy_all_courses
  get 'courses/configuration', to: 'courses#configuration', as: :configuration_courses

  # ✅ Grader Requests (single correct block)
  resources :grader_requests, only: [:index, :show, :destroy] do
    resources :grader_assignments, only: [:index, :create, :destroy]
  end

  # Courses and sections
  resources :courses do
    resources :sections, only: [:index]
  end

  # Creating grader requests from sections
  resources :sections, only: [:show, :edit, :update, :destroy] do
    resource :grader_request, only: [:create]
  end

  get "assignments_list", to: "grader_assignments#assignments_list"
  delete "grader_assignments/:id", to: "grader_assignments#destroy", as: :grader_assignment

  # Grader application
  resource :grader_application, only: [:show, :new, :create, :edit, :update]

  # Notifications
  get "notifications", to: "notifications#index"

  # Recommendation Form for Instructors
  resources :recommendations do
    collection do
      get :by_last_name_id
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end