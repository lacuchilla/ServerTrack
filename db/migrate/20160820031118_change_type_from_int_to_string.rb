class ChangeTypeFromIntToString < ActiveRecord::Migration[5.0]
  def change
    change_column :records, :server_id, :string
  end
end
