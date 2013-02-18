require 'spec_helper'

describe StockQuoteHelper do
  it 'should return the proper de-normalized stock symbol for NSE' do
    symbol = "ITC"
    exchange = "NSE"
    StockQuoteHelper::denormalize_symbol(symbol, exchange).should == "ITC.NS"
  end

  it 'should return the proper normalized stock symbol for NSE' do
    symbol = "ITC.NS"
    StockQuoteHelper::normalize_symbol(symbol).should == "ITC"
  end

  it 'should return the proper de-normalized stock symbol for BSE' do
    symbol = "ITC"
    exchange = "BSE"
    StockQuoteHelper::denormalize_symbol(symbol, exchange).should == "ITC.BO"
  end

  it 'should return the proper normalized stock symbol for BSE' do
    symbol = "ITC.BO"
    StockQuoteHelper::normalize_symbol(symbol).should == "ITC"
  end

  it 'should return the appropriate stock price for a single stock' do
    symbol = "ITC"
    exchange = "BSE"

    prices = StockQuoteHelper::get_price([[symbol, exchange]])
    prices[prices.keys[0]].lastTrade.should == 300.30
  end

  it 'should return the appropriate stock price for multiple stocks' do
    stock1 = ["ITC","NSE"]
    stock2 = ["RELIANCE","NSE"]

    prices = StockQuoteHelper::get_price([stock1, stock2])
    prices[StockQuoteHelper.denormalize_symbol(stock1[0], stock1[1])].lastTrade.should == 300.30
    prices[StockQuoteHelper.denormalize_symbol(stock2[0], stock2[1])].lastTrade.should == 847.5
  end
end

