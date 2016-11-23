FactoryGirl.define do
  factory :user do
    id 1
    email "user1@example.com"
    password "user1password"


    factory :user2 do
      id 2
      email "user2@example.com"
      password "user2password"
    end

  end
end
