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
  end
end
