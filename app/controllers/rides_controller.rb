class RidesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ride, only: [ :show, :update, :join, :cancel ]

  def index
    @rides = current_user.passenger_profile.rides.includes(:driver_profile)
  end

  def new
    @ride = Ride.new
  end

  def create
    @ride = current_user.passenger_profile.rides.build(ride_params)

    if @ride.save
      broadcast_ride_request
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @ride, notice: "Ride requested successfully." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
    return unless @ride.pending?

    @ride_follower = RideFollower.new(ride: @ride, passenger_profile: current_user.passenger_profile)

    if @ride_follower.save
      Turbo::StreamsChannel.broadcast_append_to(
        "ride_#{@ride.id}_followers",
        target: "ride_followers",
        partial: "rides/follower",
        locals: { follower: current_user.passenger_profile }
      )
    end
  end

  private

  def set_ride
    @ride = Ride.find(params[:id])
  end

  def ride_params
    params.require(:ride).permit(:pickup_location, :dropoff_location, :scheduled_time)
  end

  def broadcast_ride_request
    nearby_drivers = DriverProfile.available.near(@ride.pickup_location, 5)
    nearby_drivers.each do |driver|
      Turbo::StreamsChannel.broadcast_append_to(
        driver,
        target: "available_rides",
        partial: "rides/ride_request",
        locals: { ride: @ride }
      )
    end
  end
end
