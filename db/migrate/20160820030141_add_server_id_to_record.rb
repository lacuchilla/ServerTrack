class AddServerIdToRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :server_id, :integer
  end
end
