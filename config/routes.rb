Rails.application.routes.draw do
  # devise_for :users
  devise_for :users

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
  end

  # root :to => "posts#index"
  resources :posts
  root to: "posts#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  get '*all', to: 'application#index', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
