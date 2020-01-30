class AddDefaultToProjectReviews < ActiveRecord::Migration[5.2]
  def change
    change_column :project_reviews, :action_required, :boolean, default: true
  end
end
