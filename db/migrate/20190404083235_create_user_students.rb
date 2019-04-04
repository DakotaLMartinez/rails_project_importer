class CreateUserStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :user_students do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :student, foreign_key: true

      t.timestamps
    end
  end
end
