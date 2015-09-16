class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    if @user.nickname.to_s.empty?
      return redirect_to new_user_session_path
    end
    @user_setting = @user.user_setting || UserSetting.init(@user)
    @user_status = @user.user_status || UserStatus.init(@user)
    @reverse_mode = (if params.has_key?('reverse_mode')
                       params[:reverse_mode].to_i == UserSetting::REVERSE_MODE
                     else
                       @user_setting.is_reverse_mode?
                     end) ? UserSetting::REVERSE_MODE : UserSetting::NORMAL_MODE
    query = UserStatus.all.eager_load(:location, :user => :user_setting)
    if Settings.user_status.show_user_only_more_that_one_step
      query = query.where('user_statuses.total_distance > 0')
    end
    # where('user_settings.reverse_mode = ?', @reverse_mode).
    @current_statuses = query.order('user_statuses.total_distance desc')
    @overview_polyline = LocationRoute.overview_polyline
  end
end
