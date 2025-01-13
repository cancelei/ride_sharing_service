class CreateDriverProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :driver_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cab_association, null: false, foreign_key: true
      t.string :license_number, null: false
      t.integer :status, default: 0
      t.decimal :rating, precision: 3, scale: 2
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.boolean :active, default: true
      t.timestamps null: false
    end

    add_index :driver_profiles, :license_number, unique: true
    add_index :driver_profiles, :status
    add_index :driver_profiles, [ :latitude, :longitude ]
  end
end
