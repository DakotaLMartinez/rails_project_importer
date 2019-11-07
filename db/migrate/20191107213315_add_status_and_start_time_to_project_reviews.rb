class AddStatusAndStartTimeToProjectReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :project_reviews, :status, :string
    add_column :project_reviews, :start_time, :string
  end
end
