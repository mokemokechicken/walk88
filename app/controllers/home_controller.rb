class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @user_setting = @user.user_setting || UserSetting.init(@user)
    @user_status = @user.user_status || UserStatus.init(@user)
    @reverse_mode = (if params.has_key?('reverse_mode')
                       params[:reverse_mode].to_i == UserSetting::REVERSE_MODE
                     else
                       @user_setting.is_reverse_mode?
                     end) ? UserSetting::REVERSE_MODE : UserSetting::NORMAL_MODE
    @current_statuses = UserStatus.all.eager_load(:location, :user => :user_setting).
        where('user_statuses.total_distance > 0').
        # where('user_settings.reverse_mode = ?', @reverse_mode).
        order('user_statuses.total_distance desc')

    @overview_polyline = LocationRoute.overview_polyline
  end
end
