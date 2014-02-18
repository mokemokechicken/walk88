FactoryGirl.define do
  factory :user do
    sequence(:nickname) {|n| "user#{n}"}
    user_status
    user_setting
  end

  factory :group do
    sequence(:name) {|n| "group#{n}"}
  end

  factory :group_user do
  end

  factory :user_record do
  end

  factory :user_status do
    total_step 2300
    total_distance 23
  end

  factory :user_setting do
    reverse_mode UserSetting::NORMAL_MODE
  end
end
