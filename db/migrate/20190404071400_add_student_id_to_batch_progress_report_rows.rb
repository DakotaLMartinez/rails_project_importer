class AddStudentIdToBatchProgressReportRows < ActiveRecord::Migration[5.2]
  def change
    add_column :batch_progress_report_rows, :student_id, :integer
  end
end
