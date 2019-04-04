class BatchProgressReportRow < ApplicationRecord
  belongs_to :batch_progress_report
  belongs_to :student

  def full_name 
    student.full_name
  end

  def email 
    student.email
  end
end
