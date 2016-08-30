class CreateServers < ActiveRecord::Migration[5.0]
  def change
    create_table :servers do |t|

      t.timestamps
    end
  end
end
