Rails.application.routes.draw do
  get 'order_items/destroy'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "font", to: "pages#font"
  get 'dashboard', to: 'pages#dashboard'

  resources :items
  resources :orders

  resources :order_items, only: [:create, :destroy] do
    member do
      patch :update_quantity
    end
  end


end
