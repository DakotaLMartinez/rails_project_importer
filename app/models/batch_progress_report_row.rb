class BatchProgressReportRow < ApplicationRecord
  belongs_to :batch_progress_report
  belongs_to :student

  def full_name 
    student.try(:full_name) || 'N/A'
  end

  def email 
    student.try(:email) || 'N/A'
  end

  def github_username
    student.try(:github_username) || 'N/A'
  end
end
