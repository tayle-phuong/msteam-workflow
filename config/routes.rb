Rails.application.routes.draw do
  resources :submits, only: %i[index show destroy]
  resources :workflows do
    member do
      post :send_cheer, :send_survey, :send_auto
    end
  end

  resource :submit, controller: :submit, only: %i[create] do
    get "/", to: "submits#index"
  end

  resource :me, controller: :me, only: %i[show]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
