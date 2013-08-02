require 'open-uri'
require 'ostruct'

module Map
  module_function

  def get_directions(loc_start, loc_end)
    uri = "http://maps.googleapis.com/maps/api/directions/json?sensor=false&mode=walking&region=jp&language=ja"
    uri += "&origin=#{loc_start.lat.to_s},#{loc_start.lon.to_s}"
    uri += "&destination=#{loc_end.lat.to_s},#{loc_end.lon.to_s}"

    str = open(uri).read
    data = JSON.parse(str)

    unless data['status'] == 'OK'
      return nil
    end

    ret = OpenStruct.new
    ret.distance = data['routes'][0]['legs'][0]['distance']['value']
    ret.polyline = data['routes'][0]['overview_polyline']['points']
    ret
  end
end
