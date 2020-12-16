FactoryBot.define do
  factory :task do
    sequence(:title, "title_1")
    content { 'content' }
    status { 0 }
    deadline { Date.current.in_time_zone }
    association :user
  end
end
