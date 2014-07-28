class UsersController < ApplicationController
  before_action :set_user, only: [:picture]

  def picture
    send_data UserPin.new(@user.id, @user.image).pin, :disposition => 'inline', :type => 'image/png'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
