FactoryGirl.define do
  factory :user do
    name     "Harish Porwal"
    email    "harish.porwal@gmail.com"
    password "password"
    password_confirmation "password"
  end

  factory :stock_watchlist do
    symbol "ITC"
    exchange "NSE"
    classification "INVESTMENT"
    notes 'Good Defensive Investment Stock'

    factory :stock_watchlist_trading do
      classification "TRADING"
    end
  end

  factory :watch_parameter do
    name WatchParameter::EMA_50
    watch_level nil

    factory :watch_parameter_ema_50 do
      name WatchParameter::EMA_50
      watch_level nil
    end

    factory :watch_parameter_ema_100 do
      name WatchParameter::EMA_100
      watch_level nil
    end

    factory :watch_parameter_ema_200 do
      name WatchParameter::EMA_200
      watch_level nil
    end

    factory :watch_parameter_breakout_level do
      name WatchParameter::BREAKOUT_LEVEL
      watch_level 100
    end

    factory :watch_parameter_resistance_level do
      name WatchParameter::RESISTANCE_LEVEL
      watch_level 200
    end

    factory :watch_parameter_price do
      name WatchParameter::PRICE
      watch_level 300
    end  
  end
end
