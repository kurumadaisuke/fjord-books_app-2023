Rails.application.routes.draw do
  # devise_for :users, controllers: { registrations: 'users/registrations' }
  #   get "users/show" => "users#show"
  # get 'users/show'

  root to: 'books#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users/index' => 'users#index'
    get '/users/:id' => 'users#show'
  end
  resources :books
end
