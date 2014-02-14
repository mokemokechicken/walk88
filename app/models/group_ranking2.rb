class GroupRanking2 < ActiveRecord::Base
  START_DATE = '2014-02-01'
  END_DATE   = '2014-03-01'

  def self.ranking_list(start_date=START_DATE, end_date=END_DATE)
    records = ActiveRecord::Base.connection.execute <<-SQL
      SELECT g.id as id, g.name as name, gu.user_id as user_id, sum(r.steps) as steps, sum(r.distance) as distance
      FROM groups g
      JOIN group_users gu ON (g.id = gu.group_id)
      JOIN user_records r ON (gu.user_id = r.user_id)
      WHERE r.day >= '#{start_date}' and r.day < '#{end_date}'
      GROUP BY g.id, g.name, gu.user_id
      ORDER BY g.id, gu.user_id
    SQL
    calc_group_distance(records)
  end

  def self.calc_group_distance(records)
    groups = {}
    records.each do |rec|
      groups[rec['id']] ||= []
      groups[rec['id']] << rec
    end
    ret = []
    groups.values.each do |user_list|
      u = user_list[0]
      hash = {
          'id' => u['id'],
          'name' => u['name'],
          'distance' => calc_distance(user_list.map{|x| x['distance']}),
      }
      ret << hash
    end

    ret.sort_by {|x| -x['distance']}
  end

  def self.ranking_list_by_day(start_date=START_DATE, end_date=END_DATE)
    records = ActiveRecord::Base.connection.execute <<-SQL
      SELECT g.id as id, g.name as name, r.day as day, gu.user_id as user_id, r.steps as steps, r.distance as distance
      FROM groups g
      JOIN group_users gu ON (g.id = gu.group_id)
      JOIN user_records r ON (gu.user_id = r.user_id)
      WHERE r.day >= '#{start_date}' and r.day < '#{end_date}'
      -- GROUP BY g.id, g.name, r.day, gu.user_id
      ORDER BY g.id, r.day
    SQL
    ret = []

    cur_group = nil
    group_user_array = nil
    group_array = []
    user_distance = Hash.new(0)
    records << Hash.new(0)
    records.each do |record|
      user_distance[record['user_id']] += record['distance']
      distance = user_distance[record['user_id']]
      if cur_group && cur_group['id'] == record['id'] && cur_group['day'] == record['day']
        group_user_array << distance
      else
        if group_user_array
          group_array.push({
              'id'       => cur_group['id'],
              'name'     => cur_group['name'],
              'day'      => cur_group['day'],
              'distance' => calc_distance(group_user_array),
          })
        end
        group_user_array = [distance]
      end
      if cur_group && cur_group['id'] != record['id']
        ret << group_array
        group_array = []
      end
      cur_group = record
    end
    ret
  end

  def self.calc_distance(distance_list)
    calc_distance_simple(distance_list)
  end

  def self.calc_distance_simple(distance_list)
    distance_list.reduce(:+)
  end

  def self.calc_distance_with_sigma(distance_list)
    avg = distance_list.reduce(:+).to_f / distance_list.size
    return 0 if avg == 0
    sigma = calc_sigma(distance_list)
    ratio = [1-(1.0*sigma/avg), 0].max
    z = distance_list.reduce(:+) * (2**ratio)
    z
  end

  def self.calc_sigma(distance_list)
    avg = distance_list.reduce(:+).to_f / distance_list.size
    Math.sqrt(distance_list.map{|x| (x-avg)**2}.reduce(:+) / distance_list.size)
  end
end

