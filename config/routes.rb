Rails.application.routes.draw do
  
  resources :batches do 
    resources :batch_progress_reports, as: :progress_reports
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'batches#index'
end
