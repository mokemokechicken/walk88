class Api::LocationController < ApplicationController
  def index
    locations = Location.all.order(:number)
    render :json => locations
  end
end
