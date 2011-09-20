class CreateLocationsMonitorProfiles < ActiveRecord::Migration
  def up
    create_table :locations_monitor_profiles, :id => false do |t|
      t.integer :location_id, :null => false
      t.integer :monitor_profile_id, :null => false
    end
  end

  def down
    drop_table :locations_monitor_profiles
  end
end
