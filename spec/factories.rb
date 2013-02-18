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

  factory :stock_watch_parameter do
    ma_50 1
    ma_100 1
    ma_200 1
    resistance 200
    breakout 250
    price 220

    association :stock_watchlist, factory: :stock_watchlist
  end

  factory :stock_data do
    ma_50 100
    ma_100 80
    ma_200 70
    price 105
  end
 
  factory :stock_stock_data do
    ma_50 100
    ma_100 80
    ma_200 70
    price 105

    association :stock_watchlist, factory: :stock_watchlist
  end
  
  factory :tag do
    sequence(:name) {|n| "Tag#{n}"}
  end

  factory :stock_tag, class: Tag do
    sequence(:name) {|n| "Stock Tag#{n}"}
    association :taggable, factory: :stock_watchlist
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
    association :stock_data, factory: :stock_data
  end
end
