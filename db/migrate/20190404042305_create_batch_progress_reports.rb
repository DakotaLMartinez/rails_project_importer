class CreateBatchProgressReports < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_progress_reports do |t|
      t.belongs_to :batch, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
