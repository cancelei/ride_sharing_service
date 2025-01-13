class PassengerProfile < ApplicationRecord
  belongs_to :user
  has_many :rides
  has_many :reviews, as: :reviewable
  has_many :led_group_rides, class_name: 'Ride', foreign_key: 'leader_id'
  has_many :followed_rides, through: :ride_followers
  
  broadcasts_refreshes
end 