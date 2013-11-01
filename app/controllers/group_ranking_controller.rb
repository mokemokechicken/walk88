class GroupRankingController < ApplicationController
  def index
    @user = current_user
    @group_ranking = GroupRanking.ranking_list
    @my_group = GroupUser.find_by(user_id: @user.id)
    @group_users = GroupUser.all.to_a
  end
end
