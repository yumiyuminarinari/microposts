Rails.application.routes.draw do
  root 'static_pages#home'

  get    'signup', to: 'users#new'
  # login、logoutというパスでそれぞれ、ログイン、ログアウトできるようにしている
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users do
    member do
      get  'edit_address', to: 'users#edit_address'
      patch 'edit_address_complete', to: 'users#edit_address_complete'
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts

end
