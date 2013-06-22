json.array!(@user_records) do |user_record|
  json.extract! user_record, :user_id, :day, :steps, :distance
  json.url user_record_url(user_record, format: :json)
end
