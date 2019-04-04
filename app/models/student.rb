class Student < ApplicationRecord
  belongs_to :user
  has_many :batch_progress_report_rows
end
