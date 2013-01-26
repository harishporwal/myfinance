FactoryGirl.define do
  factory :user do
    name     "Harish Porwal"
    email    "harish.porwal@gmail.com"
    password "password"
    password_confirmation "password"
  end

  factory :watch_parameter do
    ma_50 1
    ma_100 1
    ma_200 1
    resistance 200
    breakout 250
    price 220
  end

  factory :tags do
    name "Breakout Watch"
  end
  
  factory :stock_watchlist do
    sequence(:symbol) {|n| "ITC#{n}"}
    exchange "NSE"
    classification "INVESTMENT"
    notes 'Good Defensive Investment Stock'

    factory :stock_watchlist_trading do
      classification "TRADING"
    end

    association :watch_parameter, factory: :watch_parameter
  end
end
