require 'csv'

class Import88Data
  def self.execute(filename=nil)
    filename ||= File.dirname(__FILE__) + '/data/88.tsv'
    new(filename).import
  end

  def initialize(filename)
    @filename = filename
  end

  def import
    Location.delete_all
    total_distance = 0
    CSV.open(@filename, 'r', :col_sep => "\t") do |csv|
      csv.each_with_index do |record, i|
        next if record.size < 5
        lat, lon = convert_lat_lon(record[2], record[3])
        Location.create(
            number: i+1,
            name: record[0],
            address: record[1],
            lat: lat,
            lon: lon,
            next_distance: record[4].to_f,
            total_distance: total_distance
        )
        total_distance += record[4].to_f
      end
    end
  end

  def convert_lat_lon(lat_str, lon_str)
    lat = conv(lat_str)
    lon = conv(lon_str)
    wgs_lat = lat - lat * 0.00010695 + lon * 0.000017464 + 0.0046017
    wgs_lon = lon - lat * 0.000046038 - lon * 0.000083043 + 0.010040
    return wgs_lat, wgs_lon
  end

  def conv(v)
    vv = v[1..-1].split('.').map{|x| x.to_i}
    vv[0] + vv[1] / 60.0 + vv[2] / 3600.0
  end
end