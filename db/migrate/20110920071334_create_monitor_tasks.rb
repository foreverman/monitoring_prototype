class CreateMonitorTasks < ActiveRecord::Migration
  def change
    create_table :monitor_tasks do |t|
      t.datetime :next_scheduled_at
      t.integer :location_id
      t.integer :monitor_profile_id
      t.integer :lock_version, :null => false, :default => 0
      t.boolean :realtime, :null => false, :default => false

      t.timestamps
    end
  end
end
