require 'csv'
require 'builder'

namespace :walk88 do
  namespace :map do
    desc "Import point data from CSV file"
    task import: :environment do
      print "Importing from point data... "

      filename ||= File.join(Rails.root, 'lib', 'assets', '88.tsv')

      Location.delete_all
      if 'sqlite3' == ActiveRecord::Base.connection.instance_values['config'][:adapter]
        ActiveRecord::Base.connection.execute "DELETE FROM sqlite_sequence WHERE name='locations'"
      end

      total_distance = 0
      count = 0
      CSV.open(filename, 'r', :col_sep => "\t") do |csv|
        csv.each_with_index do |record, i|
          next if record.size < 5
          Location.create(
            number: i + 1,
            name: record[0],
            address: record[4],
            lat: record[1].to_f,
            lon: record[2].to_f,
            next_distance: record[3].to_f,
            total_distance: total_distance
          )
          total_distance += record[3].to_f
          count += 1
        end
      end

      print "loaded #{count} points. "
      puts "done".green
    end

    namespace :direction do
      desc "Create direction data from each way points"
      task create: :environment do
        puts "Creating direction data..."
        points = Location.all

        LocationRoute.delete_all
        if 'sqlite3' == ActiveRecord::Base.connection.instance_values['config'][:adapter]
          ActiveRecord::Base.connection.execute "DELETE FROM sqlite_sequence WHERE name='location_routes'"
        end

        while points.size >= 2
          print "Getting directions from #{points[0].number}:#{points[0].name} to #{points[1].number}:#{points[1].name}..."

          rcount = 0
          begin
            direction = Map.get_directions points[0], points[1]
          rescue
            if rcount < 10
              rcount += 1
              sleep 5
              print "."
              retry
            end
            raise $!
          end

          if direction == nil
            print " no routes "

            LocationRoute.create(
              start_id: points[0].id,
              end_id: points[1].id,
              distance: 0,
              polyline: ''
            )

            puts "skipped".red
          else
            print " distance:#{direction.distance}m "

            LocationRoute.create(
              start_id: points[0].id,
              end_id: points[1].id,
              distance: direction.distance,
              polyline: direction.polyline
            )

            puts "done".green
          end

          sleep 1
          points.shift
        end
      end

      desc "Calculate distance between each 2 points"
      task distance: :environment do
        puts "Calculating distance data..."

        locations = {}
        Location.all.each do |l|
          locations[l.id] = l
        end

        total = 0
        LocationRoute.all.each do |r|
          ls = locations[r.start_id]
          le = locations[r.end_id]
          polyline = []
          polyline << [ls.lat, ls.lon]
          polyline += Polylines::Decoder.decode_polyline r.polyline if r.polyline != ''
          polyline << [le.lat, le.lon]

          ps = polyline.shift
          dist = 0
          polyline.each do |p|
            dist += Geocoder::Calculations.distance_between(ps, p, units: :km)
            ps = p
          end
          total += dist

          ls.next_distance = dist.round(1)
          le.total_distance = total.round(1)
          ls.save
          le.save
          print "#{ls.id}:#{ls.name} - #{le.id}:#{le.name} = #{dist.round(1)}km #{total.round(1)}km "
          puts "done".green
        end
      end
    end

    namespace :kml do
      desc "Create kml file from locations and routes"
      task create: :environment do
        print "Creating kml file... "

        locations = {}
        Location.all.each do |l|
          locations[l.id] = l
        end

        routes = {}
        LocationRoute.all.each do |r|
          routes[r.start_id] = r
        end

        out = File.join(Rails.root, 'public', 'assets', 'routes.kml')

        xml = Builder::XmlMarkup.new(:target => File.open(out, 'w'), :indent => 2)
        xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
        xml.kml :xmlns => 'http://earth.google.com/kml/2.2' do
          xml.Document do
            xml.name 'walk88 kml'
            xml.description ''

            # style for location
            xml.Style :id => 'location' do
              xml.IconStyle do
                xml.Icon do
                  xml.href 'http://maps.google.com/mapfiles/kml/paddle/red-circle_maps.png'
                end
              end
            end

            # style for route
            xml.Style :id => 'route' do
              xml.LineStyle do
                xml.color '80FF7300'
                xml.width 5
              end
            end

            # locations
            locations.each_value do |l|
              xml.Placemark do
                xml.name l.name
                xml.description ''
                xml.address l.address
                xml.styleUrl '#location'
                xml.Point do
                  xml.coordinates "#{l.lon},#{l.lat}"
                end
              end
            end

            # routes
            routes.each_value do |r|
              ls = locations[r.start_id]
              le = locations[r.end_id]

              xml.Placemark do
                xml.name "#{ls.number}:#{ls.name} - #{le.number}:#{le.name}"
                xml.description ''
                xml.styleUrl '#route'
                xml.LineString do
                  arr = []
                  arr << "#{ls.lon},#{ls.lat}"
                  unless r.polyline == ''
                    Polylines::Decoder.decode_polyline(r.polyline).each do |p|
                      arr << "#{p[1]},#{p[0]}"
                    end
                  end
                  arr << "#{le.lon},#{le.lat}"

                  xml.tessellate 1
                  xml.coordinates arr.join(' ')
                end
              end
            end
          end
        end

        puts "done".green
      end

    end
  end
end
