class AddNotesToProjectReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :project_reviews, :notes, :text
    add_column :project_reviews, :email_to_student, :text
    add_column :project_reviews, :pass, :boolean
    add_column :project_reviews, :grade, :integer
    add_column :project_reviews, :action_required, :boolean
  end
end
