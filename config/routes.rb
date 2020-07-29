Rails.application.routes.draw do
  resources :accounts, only: [:index]
  resources :transactions, only: [:index, :show]

  post 'inbound/event', to: 'inbound#event'

  root :to => 'accounts#index'
end
