class UserSettingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user_setting, only: [:show, :edit, :update, :destroy]

  # GET /user_settings/1
  # GET /user_settings/1.json
  def show
  end

  # GET /user_settings/1/edit
  def edit
  end

  # PATCH/PUT /user_settings/1
  # PATCH/PUT /user_settings/1.json
  def update
    respond_to do |format|
      if @user_setting.update(user_setting_params) && @user.update(user_params)
        UserStatus.update_user_status(@user_setting.user_id)
        format.html { redirect_to user_settings_path, notice: '保存しました' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_setting
      @user_setting = UserSetting.find(current_user.id)
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_setting_params
      # params.require(:user_setting).permit(:step_dist, :reverse_mode)
      {}
    end

    def user_params
      params.require(:user).permit(:nickname)
    end
end
