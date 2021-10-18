FactoryBot.define do
  factory :rank do
    # 1対１
    association :user
    rank { 1 }
    score { 1 }
  end
end