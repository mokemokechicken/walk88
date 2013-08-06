class LocationRoute < ActiveRecord::Base
  def self.overview_polyline
    locations = Location.order('number').all

    routes = {}
    LocationRoute.all.each do |r|
      routes[r.start_id] = r
    end

    polyline = []
    locations.each do |loc|
      polyline << [loc.lat, loc.lon]
      polyline += Polylines::Decoder.decode_polyline routes[loc.number].polyline if routes.has_key? loc.number and routes[loc.number].polyline != ''
    end

    Polylines::Encoder.encode_points polyline
  end
end
