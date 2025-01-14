class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_one :driver_profile
  has_one :passenger_profile
  has_one :cab_association

  enum :role, { passenger: 0, driver: 1, cab_association: 2, admin: 3 }

  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true, phone: { possible: true, allow_blank: true }
  validates :whatsapp_number, phone: { possible: true, allow_blank: true }
  validates :telegram_username, format: { with: /\A@?[a-zA-Z0-9_]{5,32}\z/ }, allow_blank: true

  # Notification preferences validation
  validate :validate_notification_preferences

  # Notification channels setup
  after_initialize :set_default_notification_preferences, if: :new_record?

  # Notification methods
  def notify(notification)
    enabled_channels.each do |channel|
      send_notification_through(channel, notification)
    end
  end

  def enabled_channels
    notification_preferences.select { |channel, enabled| enabled }.keys
  end

  private

  def set_default_notification_preferences
    self.notification_preferences ||= {
      email: true,
      whatsapp: false,
      telegram: false
    }
  end

  def validate_notification_preferences
    unless notification_preferences["email"] == true
      errors.add(:notification_preferences, "Email notifications cannot be disabled")
    end

    if notification_preferences["whatsapp"] && whatsapp_number.blank?
      errors.add(:whatsapp_number, "is required for WhatsApp notifications")
    end

    if notification_preferences["telegram"] && telegram_username.blank?
      errors.add(:telegram_username, "is required for Telegram notifications")
    end
  end

  def send_notification_through(channel, notification)
    case channel.to_sym
    when :email
      UserMailer.notification_email(self, notification).deliver_later
    when :whatsapp
      WhatsappNotificationJob.perform_later(self, notification)
    when :telegram
      TelegramNotificationJob.perform_later(self, notification)
    end
  end

  broadcasts_refreshes
end
