class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @user_setting = UserSetting.find_or_create_by(id: @user.id)
  end
end
