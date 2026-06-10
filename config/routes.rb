Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/health", to: "health_checks#show"

  namespace :api do
    namespace :v1 do
      resources :shops, only: [] do
        collection do
          post "register"
          post "login"
          post "logout"
          post "refresh_token"
        end
      end

      resources :products do
        member do
          put :publish
          put :unpublish
        end

        collection do
          get :published
          get :draft
        end

        resources :comments, only: [ :index, :create, :update, :destroy ], controller: "products/comments"
      end

      resources :comments do
        member do
          get :replies
        end
      end

      resources :discounts do
        collection do
          post :amount
        end
      end

      resource :cart, only: [ :show ] do
        resources :items, only: %i[create update destroy], controller: :cart_items
      end

      resources :inventories

      namespace :checkout do
        post :review
      end

      resources :notifications, only: [ :index ]

      post "/direct_uploads", to: "direct_uploads#create"
      post "/presigned_uploads", to: "presigned_uploads#create"

      get "search", to: "search#index"

      get "", to: "products#index"
    end
  end
end
