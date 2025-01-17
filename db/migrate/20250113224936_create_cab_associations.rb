class CreateCabAssociations < ActiveRecord::Migration[8.0]
  def change
    create_table :cab_associations do |t|
      t.string :name
      t.string :company_name, null: false
      t.string :registration_number, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
