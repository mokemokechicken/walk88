class Api::UserStatusController < ApplicationController
  def index
    reverse_mode = params[:reverse_mode].to_s.to_i == UserSetting::REVERSE_MODE ? UserSetting::REVERSE_MODE : UserSetting::NORMAL_MODE
    current_statuses = UserStatus.all_data(reverse_mode)
    render :json => current_statuses
  end

  def show
    status = UserStatus.find_by_user_id(params[:id])
    render :json => status
  end
end
