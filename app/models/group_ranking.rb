class GroupRanking < ActiveRecord::Base
  START_DATE = '2013-11-01'
  END_DATE = '2013-12-01'

  def self.ranking_list
    records = ActiveRecord::Base.connection.execute <<-SQL
      SELECT g.id as id, g.name as name, sum(r.steps) as steps, sum(r.distance) as distance
      FROM groups g
      JOIN group_users gu ON (g.id = gu.group_id)
      JOIN user_records r ON (gu.user_id = r.user_id)
      WHERE r.day >= '#{START_DATE}' and r.day < '#{END_DATE}'
      GROUP BY g.id, g.name
      ORDER BY avg(r.distance) DESC
    SQL
    members = Group.joins(:group_user).group('groups.id').count
    records.each do |rec|
      rec['avg_steps']    = 1.0 * rec['steps']    / members[rec['id']]
      rec['avg_distance'] = 1.0 * rec['distance'] / members[rec['id']]
    end
    records.sort_by {|x| -x['distance']}
  end

  def self.ranking_list_by_day
    records = ActiveRecord::Base.connection.execute <<-SQL
      SELECT g.id as id, g.name as name, r.day as day, sum(r.steps) as steps, sum(r.distance) as distance
      FROM groups g
      JOIN group_users gu ON (g.id = gu.group_id)
      JOIN user_records r ON (gu.user_id = r.user_id)
      WHERE r.day >= '#{START_DATE}' and r.day < '#{END_DATE}'
      GROUP BY g.id, g.name, r.day
      ORDER BY g.id, r.day
    SQL
    ret = []
    cur_array = cur_val = nil
    records.each do |record|
      if cur_val == record['id']
        cur_array << record
      else
        cur_val = record['id']
        cur_array = [record]
        ret << cur_array
      end
    end
    ret
  end
end

