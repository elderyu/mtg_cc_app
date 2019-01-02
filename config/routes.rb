Rails.application.routes.draw do
root 'static_pages#home'

  get 'collected_cards/create'
  get 'collected_cards/destroy'

  get 'home', to: 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'contact', to: 'static_pages#contact'

  resources :users
  get 'signup', to: 'users#new'
  get 'home', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :cards
  post 'search', to: 'cards#find'
  get 'search', to: 'cards#search'

  resources :collected_cards
  post 'add', to: 'collected_cards#create'
  get 'collection', to: 'collected_cards#show'

  resources :decks


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
