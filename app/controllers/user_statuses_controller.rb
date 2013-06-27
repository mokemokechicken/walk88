class UserStatusesController < ApplicationController
  def index
    current_statuses = UserStatus.all.
        eager_load(:user).
        order('total_distance desc').
        where('total_distance > 0').
        map {|us| {
          id: us.user_id,
          lat: us.lat,
          lon: us.lon,
          nickname: us.user.nickname,
          image: us.user.image,
          location_id: us.location_id,
          next_location_id: us.next_location_id,
        }}
    render :json => current_statuses
  end
end
