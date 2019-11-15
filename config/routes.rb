Rails.application.routes.draw do
  
  resources :project_reviews
  resources :projects
  devise_for :users
  resources :students do 
    resources :projects, only: [:index]
  end
  resources :batch_progress_report_rows
  resources :batches do 
    resources :batch_progress_reports, as: :progress_reports
    resources :projects, only: [:index], param: :id
  end
  resources :projects, only: [:index]

  post 'students/:id/add', controller: :students, action: :add, as: :add_student
  post 'students/:id/remove', controller: :students, action: :remove, as: :remove_student
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'batches#index'
end
