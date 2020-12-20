FactoryBot.define do
  factory :task do
    sequence(:id, 1)
    sequence(:title, "title_1")
    content { 'content' }
    status { :todo }
    deadline { 1.week.from_now.time }
    association :user
  end
end
