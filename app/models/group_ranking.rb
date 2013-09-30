class GroupRanking < ActiveRecord::Base
  def self.ranking_list
    records = ActiveRecord::Base.connection.execute <<-SQL
      SELECT g.id as id, g.name as name, sum(r.steps) as steps, sum(r.distance) as distance
      FROM groups g
      JOIN group_users gu ON (g.id = gu.group_id)
      JOIN user_records r ON (gu.user_id = r.user_id)
      WHERE r.day >= '2013-10-01'
      GROUP BY g.id, g.name
      ORDER BY avg(r.distance) DESC
    SQL
    members = Group.joins(:group_user).group('groups.id').count
    records.each do |rec|
      rec['avg_steps']    = 1.0 * rec['steps']    / members[rec['id']]
      rec['avg_distance'] = 1.0 * rec['distance'] / members[rec['id']]
    end
    records.sort_by {|x| -x['avg_distance']}
  end
end

