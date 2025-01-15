class CreatePassengerProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :passenger_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :phone_number
      t.decimal :rating, precision: 3, scale: 2
      t.jsonb :preferences, default: {}
      t.boolean :active, default: true
      t.timestamps null: false
    end

    add_index :passenger_profiles, :phone_number, unique: true
    add_index :passenger_profiles, :active
  end
end
