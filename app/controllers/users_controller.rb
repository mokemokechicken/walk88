class UsersController < ApplicationController
  before_action :set_user, only: [:picture]

  def picture
    blob = ActiveSupport::Cache.lookup_store(:file_store, 'tmp/as_cache').fetch("user_pic/#{@user.id}") do
      mask_path = Rails.root.join('app', 'assets', 'images', 'mask.png').to_s
      pin_path = Rails.root.join('app', 'assets', 'images', 'pin.png').to_s

      pic = Magick::ImageList.new(@user.image).first
      pin = Magick::ImageList.new(pin_path).first
      tmp = Magick::ImageList.new(mask_path)
      tmp.alpha = Magick::ActivateAlphaChannel
      mask = tmp.fx('1-r', Magick::AlphaChannel)
      mpic = mask.composite(pic, 0, 0, Magick::SrcInCompositeOp)
      ret = pin.composite(mpic, 2, 2, Magick::OverCompositeOp)
      ret.to_blob
    end

    send_data blob, :disposition => 'inline', :type => 'image/png'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
