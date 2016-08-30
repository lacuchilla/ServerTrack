class AddNameToServerModel < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :name, :string
  end
end
