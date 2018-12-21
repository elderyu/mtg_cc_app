Rails.application.routes.draw do
root 'static_pages#home'
  get 'home', to: 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'contact', to: 'static_pages#contact'

  get 'signup', to: 'user#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
