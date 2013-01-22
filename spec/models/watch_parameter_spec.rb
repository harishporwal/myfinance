require 'spec_helper'

describe WatchParameter do
  let(:stock_watchlist) {FactoryGirl.create(:stock_watchlist)}
  before do
    @watch_parameter = stock_watchlist.build_watch_parameter(
      ma_50: 1, ma_100: 1, ma_200: 1, resistance: 200, breakout: 180, price: 200)
  end
  
  subject { @watch_parameter}

  it { should respond_to(:symbol) }
  it { should respond_to(:ma_50) }
  it { should respond_to(:ma_100) }
  it { should respond_to(:ma_200) }
  it { should respond_to(:resistance) }
  it { should respond_to(:breakout) }
  it { should respond_to(:price) }
  it { should respond_to(:stock_watchlist) }

  it { should be_valid }
end
