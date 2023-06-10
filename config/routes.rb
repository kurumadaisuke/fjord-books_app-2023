Rails.application.routes.draw do
  root to: 'books#index'
  resources :books
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users/index' => 'users#index'
    get '/users/:id' => 'users#show'
    get '/users/sign_up' => 'users#new'
    get '/users/edit' => 'users#edit'
  end
end
