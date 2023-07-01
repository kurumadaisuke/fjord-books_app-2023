Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books
  resources :reports
  resources :users, only: %i(index show)

  resources :books do
    resources :comments, only: [:create], module: :books
  end
  resources :comments, only: [:destroy]

  resources :reports do
    resources :comments, only: [:create, :destroy], module: :reports
  end
end
