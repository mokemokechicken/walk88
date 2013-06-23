class User < ActiveRecord::Base
  has_one :user_setting
  has_one :user_status
  has_many :user_record

  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      User.transaction do
        user = User.create(
            provider:auth.provider,
            uid:auth.uid,
            nickname: auth.info.nickname,
            image: auth.info.image,
            token: auth.credentials.token,
            expires_at: auth.credentials.expires_at
        )
        UserSetting.init(user)
        UserStatus.init(user)
      end
    else
      user.update({
                      nickname: auth.info.nickname,
                      image: auth.info.image,
                      token: auth.credentials.token,
                      expires_at: auth.credentials.expires_at
                  })
    end
    user
  end
end
