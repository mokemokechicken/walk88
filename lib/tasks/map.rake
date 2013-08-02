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
    end
  end
end
