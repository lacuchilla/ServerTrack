class AddCpuAndRamToRecordModel < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :cpu, :float
    add_column :records, :ram, :float
  end
end
