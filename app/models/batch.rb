class Batch < ApplicationRecord
  has_many :batch_progress_reports
  has_many :students, foreign_key: 'active_batch_id', primary_key: 'batch_id'
  has_many :projects, through: :students

  def refresh_report 
    last_report_date = batch_progress_reports.last.try(:created_at)
    if last_report_date && last_report_date < 1.second.ago
      self.batch_progress_reports.create.delay.generate_report
      puts "report job should have been generated here"
    end
  end

  def last_report_with_content 
    my_reports = batch_progress_report_ids
    last_report_with_rows = BatchProgressReportRow.where(batch_progress_report_id: my_reports).order(:created_at).last.try(:batch_progress_report)
  end

  def fetch_projects 
    data = ProjectImporter.new(self).fetch
    data.each do |project_hash|
      project = Project.find_by(id: project_hash["id"]) || Project.create(project_hash)
      project.update(status: project_hash["status"]) unless project.status == project_hash["status"]
      project.student_info = project_hash["student_info"] unless project.student
    end
  end
end
