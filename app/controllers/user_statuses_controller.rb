class UserStatusesController < ApplicationController
  def index
    reverse_mode = params[:reverse_mode].to_s.to_i == UserSetting::REVERSE_MODE ? UserSetting::REVERSE_MODE : UserSetting::NORMAL_MODE
    current_statuses = UserStatus.all.
        eager_load(:user => :user_setting).
        order('total_distance desc').
        where('total_distance > 0').
        where('user_settings.reverse_mode = ?', reverse_mode).
        map {|us| {
          id: us.user_id,
          lat: us.lat,
          lon: us.lon,
          bearing: us.bearing,
          nickname: us.user.nickname,
          image: us.user.image,
          location_id: us.location_id,
          next_location_id: us.next_location_id,
          is_reverse: us.user.user_setting.reverse_mode == UserSetting::REVERSE_MODE,
        }}
    render :json => current_statuses
  end
end
