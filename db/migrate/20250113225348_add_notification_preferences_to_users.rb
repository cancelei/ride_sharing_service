class AddNotificationPreferencesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :notification_preferences, :jsonb, default: {
      email: true,
      whatsapp: false,
      telegram: false
    }, null: false

    add_column :users, :whatsapp_number, :string
    add_column :users, :telegram_username, :string

    add_index :users, :notification_preferences, using: :gin
  end
end
