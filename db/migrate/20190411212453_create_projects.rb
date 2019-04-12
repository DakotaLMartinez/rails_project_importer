class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :project_type
      t.string :status
      t.string :github_url
      t.string :blog_url
      t.string :video_url
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
