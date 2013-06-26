class FitbitController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user_setting, only: [:login, :callback, :login_success]

  def login
    client = Fitbit.create_client
    if @user_setting.exist_fitbit_token?
      begin
        client.reconnect(@user_setting.fitbit_token, @user_setting.fitbit_secret)
        info = Fitbit.fetch_info_by_day(client, 'today')
        unless info[:errors]
          return redirect_to fitbit_login_success_url
        end
        @user_setting.invalidate_fitbit
      rescue Exception
      end
    end

    request_token = client.request_token
    session[:token] = token = request_token.token
    session[:secret] = request_token.secret
    redirect_to "http://www.fitbit.com/oauth/authorize?oauth_token=#{token}"
  end

  def callback
    verifier = params[:oauth_verifier]
    token = session[:token]
    secret = session[:secret]
    client = Fitbit.create_client
    access_token = client.authorize(token, secret, { :oauth_verifier => verifier })
    fitbit_user_id = client.user_info['user']['encodedId']
    @user_setting.update_attributes({
        fitbit_token: access_token.token,
        fitbit_secret: access_token.secret,
        fitbit_user_id: fitbit_user_id,
                          })
    redirect_to fitbit_login_success_url
  end

  def login_success
    client = Fitbit.create_client
    client.reconnect(@user_setting.fitbit_token, @user_setting.fitbit_secret)
    @today = Fitbit.fetch_info_by_day(client, 'today')
    if @today[:errors]
      @errors = @today[:errors]
      render 'connect_failure'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  # @return [UserSetting]
  def set_user_setting
    @user_setting = current_user.user_setting
  end
end
