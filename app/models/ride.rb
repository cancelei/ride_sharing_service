class Ride < ApplicationRecord
  belongs_to :passenger_profile
  belongs_to :driver_profile, optional: true
  belongs_to :leader, class_name: 'PassengerProfile', optional: true
  
  has_many :ride_followers
  has_many :followers, through: :ride_followers, source: :passenger_profile
  
  has_secure_token :share_code
  
  enum :status, { pending: 0, accepted: 1, in_progress: 2, completed: 3, cancelled: 4 }
  
  validates :pickup_location, :dropoff_location, presence: true
  validates :estimated_price, presence: true, numericality: { greater_than: 0 }
  
  broadcasts_to ->(ride) { [ride.passenger_profile, "rides"] }, inserts_by: :prepend
  broadcasts_to ->(ride) { [ride.driver_profile, "rides"] }, inserts_by: :prepend
end 