Rails.application.routes.draw do
  root to: 'books#index'
  resources :books
  devise_for :users, controllers: {
    registrations: "users/registrations",
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    resources :users
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
