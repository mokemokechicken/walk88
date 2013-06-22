class User < ActiveRecord::Base
  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(
          provider:auth.provider,
          uid:auth.uid,
          nickname: auth.info.nickname,
          image: auth.info.image,
          token: auth.credentials.token,
          expires_at: auth.credentials.expires_at
      )
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
