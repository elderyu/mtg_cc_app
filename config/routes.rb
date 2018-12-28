Rails.application.routes.draw do
root 'static_pages#home'
  get 'home', to: 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'contact', to: 'static_pages#contact'

resources :users
  get 'signup', to: 'users#new'
  get 'home', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'search', to: 'cards#search'
  post 'search', to: 'cards#find'
  get 'collection', to: 'cards#collection'
  post 'add', to: 'collection#add'
  get 'add', to: 'cards#search'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
