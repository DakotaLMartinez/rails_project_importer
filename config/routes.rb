Rails.application.routes.draw do
  resources :batches
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'batches#index'
end
