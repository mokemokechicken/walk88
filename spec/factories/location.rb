FactoryGirl.define do
  factory :location do
    sequence(:number)
    name { "loc#{number}" }
  end
end
