class CreateRides < ActiveRecord::Migration[8.0]
  def change
    create_table :rides do |t|
      # Core ride details
      t.string :status, default: 'pending', null: false
      t.string :ride_code, null: false
      t.decimal :total_amount, precision: 10, scale: 2
      t.integer :ride_type, default: 0  # solo: 0, group: 1

      # Location details
      t.decimal :pickup_latitude, precision: 10, scale: 6
      t.decimal :pickup_longitude, precision: 10, scale: 6
      t.decimal :dropoff_latitude, precision: 10, scale: 6
      t.decimal :dropoff_longitude, precision: 10, scale: 6
      t.string :pickup_address
      t.string :dropoff_address

      # Associations
      t.references :leader, null: false, foreign_key: { to_table: :passenger_profiles }
      t.references :driver_profile, foreign_key: true

      # Timestamps
      t.datetime :scheduled_at
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps

      # Indexes
      t.index :ride_code, unique: true
      t.index :status
      t.index [ :pickup_latitude, :pickup_longitude ]
      t.index [ :dropoff_latitude, :dropoff_longitude ]
    end

    # Create join table for followers
    create_join_table :rides, :passenger_profiles do |t|
      t.index [ :ride_id, :passenger_profile_id ], unique: true, name: 'index_rides_passengers'
      t.index [ :passenger_profile_id, :ride_id ], name: 'index_passengers_rides'
    end
  end
end
