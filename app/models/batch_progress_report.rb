class BatchProgressReport < ApplicationRecord
  belongs_to :batch
  has_many :batch_progress_report_rows, dependent: :destroy

  def generate_report
    data = StudentProgressImporter.new(batch.batch_id).fetch
    data["students"].each do |s_hash|
      self.batch_progress_report_rows.create(
        full_name: s_hash["full_name"],
        completed_lessons_count: s_hash["completed_lessons_count"],
        total_lessons_count: s_hash["total_lessons_count"],
        email: s_hash["email"]
      )
    end
  end
end
# t.integer "batch_progress_report_id"
# t.string "full_name"
# t.integer "completed_lessons_count"
# t.integer "total_lessons_count"
# t.string "email
