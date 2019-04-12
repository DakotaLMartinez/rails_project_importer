class AddActiveBatchIdToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :active_batch_id, :integer
  end
end
