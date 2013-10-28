class WeeklyRecordsController < ApplicationController
  def index
    user_id = params[:user_id].to_i
    weekly_data = UserRecord.weekly_records(user_id)
    render :json => weekly_data[-[weekly_data.size, 10].min..-1]
  end
end
