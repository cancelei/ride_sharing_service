class CabAssociation < ApplicationRecord
  belongs_to :user
  has_many :driver_profiles
  has_many :drivers, through: :driver_profiles, source: :user

  validates :company_name, presence: true, uniqueness: true
  validates :registration_number, presence: true, uniqueness: true

  broadcasts_refreshes
end
