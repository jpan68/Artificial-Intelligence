Rails.application.routes.draw do
  root 'main#index'

  get 'homepage' => 'main#homepage'

  # Sessions
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  resources :users do
  	get 'edit_password', on: :member
  	patch 'update_password', on: :member
  end

  # Videos
  get 'videos' => 'videos#index'

end
