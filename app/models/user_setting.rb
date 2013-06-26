class UserSetting < ActiveRecord::Base
  belongs_to :user

  # @param [User] user
  def self.init(user)
    UserSetting.create(user_id: user.id)
  end

  def exist_fitbit_token?
    !fitbit_token.to_s.empty? && !fitbit_secret.to_s.empty?
  end

  def invalidate_fitbit
    update_attributes({
        fitbit_token: '',
        fitbit_secret: '',
                      })
  end
end
