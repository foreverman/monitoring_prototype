class CreateMonitorProfiles < ActiveRecord::Migration
  def change
    create_table :monitor_profiles do |t|
      t.string :name
      t.string :url
      t.integer :frequency
      t.integer :network_connection_id
      t.integer :user_id
      t.integer :browser_id

      t.timestamps
    end
  end
end
