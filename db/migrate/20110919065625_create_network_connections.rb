class CreateNetworkConnections < ActiveRecord::Migration
  def change
    create_table :network_connections do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
