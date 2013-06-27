class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @user_setting = @user.user_setting || UserSetting.init(@user)
    @user_status = @user.user_status || UserStatus.init(@user)
    @current_statuses = UserStatus.all.order('total_distance desc').where('total_distance > 0')
  end
end
