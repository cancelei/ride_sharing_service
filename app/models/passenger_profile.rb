class PassengerProfile < ApplicationRecord
  belongs_to :user
  has_many :rides
  has_many :reviews, as: :reviewable
  has_many :led_rides, class_name: "Ride", foreign_key: "leader_id"
  has_and_belongs_to_many :followed_rides,
                         class_name: "Ride",
                         join_table: "passenger_profiles_rides"

  broadcasts_refreshes
end
