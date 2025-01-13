class DriverProfile < ApplicationRecord
  belongs_to :user
  belongs_to :cab_association
  has_one :vehicle
  has_many :rides
  has_many :reviews, as: :reviewable
  
  validates :license_number, presence: true, uniqueness: true
  validates :status, presence: true
  
  enum :status, { available: 0, busy: 1, offline: 2 }
  
  broadcasts_refreshes
end 