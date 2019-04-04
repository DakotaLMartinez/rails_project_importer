class CreateBatchProgressReportRows < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_progress_report_rows do |t|
      t.belongs_to :batch_progress_report, foreign_key: true
      t.string :full_name
      t.integer :completed_lessons_count
      t.integer :total_lessons_count
      t.string :email

      t.timestamps
    end
  end
end
