FactoryGirl.define do
  factory :user do
    sequence(:nickname) {|n| "user#{n}"}
  end

  factory :group do
    sequence(:name) {|n| "group#{n}"}
  end

  factory :group_user do
  end

  factory :user_record do
  end
end
