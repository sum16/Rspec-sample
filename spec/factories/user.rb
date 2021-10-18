FactoryBot.define do
  factory :user do
    sequence(:name){ |n| "ゲームユーザー#{n}"}
  end
end

# sequenceを使用するとブロックから連番を受け取り、任意の加工をしてテストデータを作成することができる
# FactoryBot.create(:user)
# => #<User id: 2, name: "ゲームユーザー1", created_at: "2021-10-09 20:31:20.641215000 +0900", updated_at: "2021-10-09 20:31:20.641215000 +0900">
# FactoryBot.create(:user)
# => #<User id: 3, name: "ゲームユーザー2", created_at: "2021-10-09 20:32:33.148082000 +0900", updated_at: "2021-10-09 20:32:33.148082000 +0900">

# consoleでinclude FactoryBot::Syntax::Methodsを実行すると、
# FactoryBotの部分を省略してcreate(:user)のみでテストデータを作成することができる
