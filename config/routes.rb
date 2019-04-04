Rails.application.routes.draw do
  
  devise_for :users
  resources :students
  resources :batch_progress_report_rows
  resources :batches do 
    resources :batch_progress_reports, as: :progress_reports
  end

  post 'students/:id/add', controller: :students, action: :add, as: :add_student
  post 'students/:id/remove', controller: :students, action: :remove, as: :remove_student
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'batches#index'
end
