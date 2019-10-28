class Student < ApplicationRecord
  has_many :user_students 
  has_many :users, through: :user_students
  has_many :batch_progress_report_rows
  has_many :projects
  belongs_to :batch, foreign_key: 'active_batch_id', primary_key: 'batch_id'

  def added?(user)
    !user_students.find_by(user_id: user.try(:id)).nil?
  end

  def last_progress
    batch_progress_report_rows.last || Struct.new(:full_name, :completed_lesson_count, :total_lessons_count, :email, :student).new
  end
end
