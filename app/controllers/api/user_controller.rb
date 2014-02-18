class Api::UserController < ApplicationController
  def index
    render :json => User.all
  end

  def show
    render :json => User.find_by_id(params[:id])
  end
end
