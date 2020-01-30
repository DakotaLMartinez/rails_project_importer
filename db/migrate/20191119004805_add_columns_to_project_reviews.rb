class AddColumnsToProjectReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :project_reviews, :name, :string
    add_column :project_reviews, :email, :string
    add_column :project_reviews, :date, :string
    add_column :project_reviews, :github_url, :string
    add_column :project_reviews, :cohort_name, :string
    add_column :project_reviews, :learn_profile_url, :string
    add_column :project_reviews, :assessment, :string
  end
end
