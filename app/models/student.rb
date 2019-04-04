class Student < ApplicationRecord
  has_many :user_students 
  has_many :users, through: :user_students
  has_many :batch_progress_report_rows

  def added?(user)
    !user_students.find_by(user_id: user.id).nil?
  end

  def last_progress
    batch_progress_report_rows.last || Struct.new(:full_name, :completed_lesson_count, :total_lessons_count, :email, :student).new
  end
end
