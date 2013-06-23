class UserSetting < ActiveRecord::Base
  belongs_to :user

  # @param [User] user
  def self.init(user)
    UserSetting.create(user_id: user.id)
  end
end
