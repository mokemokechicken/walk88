class Users::SessionsController < ApplicationController
  def new
  end

  def destroy
    user = current_user
    session.destroy
    if user
      user.update_attributes({
          token: nil,
          expires_at: nil,
                            })
    end
    redirect_to new_user_session_path
  end
end
