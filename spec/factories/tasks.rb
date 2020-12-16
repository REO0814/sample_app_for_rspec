FactoryBot.define do
  factory :task do
    title { 'title' }
    content { 'content' }
    status { 0 }
    deadline { Date.current.in_time_zone }
    association :user
  end
end
