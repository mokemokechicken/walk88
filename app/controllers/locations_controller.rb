class LocationsController < ApplicationController
  def index
    locations = Location.all.order(:number)
    render :json => locations
  end
end
