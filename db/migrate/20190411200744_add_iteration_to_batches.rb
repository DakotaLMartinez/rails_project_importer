class AddIterationToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :iteration, :string
  end
end
