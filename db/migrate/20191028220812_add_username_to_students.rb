class AddUsernameToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :github_username, :string
  end
end
