class RemoveRecordsFromServerModel < ActiveRecord::Migration[5.0]
  def change
    remove_column :servers, :records, :string
  end
end
