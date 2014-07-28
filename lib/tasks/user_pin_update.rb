require 'net/https'
require 'uri'
require 'time'

class UserPinUpdate
  def self.execute
    new.update_cache
  end

  def update_cache
    User.all.each do |user|
      begin
        if UserPin.new(user.id, user.image).update
          puts "#{user.nickname}(id:#{user.id}) pin updated."
        end
      rescue Exception => ex
        p ex
      end
    end
  end
end
