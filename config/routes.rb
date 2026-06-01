Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

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
      end

      resources :discounts do
        collection do
          post :amount
        end
      end

      resource :cart, only: [:show] do
        resources :items, only: %i[create update destroy], controller: :cart_items
      end

      resources :inventories

      namespace :checkout do
        post :review
      end

      get "search", to: "search#index"

      get "", to: "products#index"
    end
  end
end
