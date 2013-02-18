require 'spec_helper'

describe StockWatchlist do
  before { @stock = StockWatchlist.new(symbol: "ITC", exchange: "NSE", 
                                       classification: "INVESTMENT", notes: "Leadership Stock")}

  subject { @stock}

  it { should respond_to(:symbol) }
  it { should respond_to(:exchange) }
  it { should respond_to(:classification) }
  it { should respond_to(:notes) }

  it { should respond_to(:watch_parameter) }
  it { should respond_to(:tags) }
  it { should respond_to(:stock_data) }

  it { should be_valid }

  it { StockWatchlist.should respond_to(:search).with(3).arguments }


  describe 'should not accept blank symbol' do
    before {@stock.symbol = ""}
    it { should_not be_valid }
  end

  describe 'should not accept symbols with > 15 characters' do
    before {@stock.symbol = "a" * 16}
    it { should_not be_valid }
  end

  it 'should always save symbol in upper case' do
    mixed_case_symbol = "TataGlobal"
    @stock.symbol = mixed_case_symbol
    @stock.save
    @stock.reload.symbol == mixed_case_symbol.upcase
  end

  describe "should not accept duplicate symbols" do
    before do
      @stock.save
    end
    let (:another_stock) {StockWatchlist.new(symbol: StockWatchlist.all(limit:1).first().symbol, 
                               exchange: "NSE",  classification: "INVESTMENT", 
                               notes: "Another Leadership Stock")}
    subject {another_stock}
    it {should_not be_valid}
  end
 
  describe 'should not accept blank exchange' do
    before {@stock.exchange= ""}
    it { should_not be_valid }
  end
  
  describe "check for exchange format - NSE/BSE" do
    it "exchange format should be valid for NSE" do
      nse_exchange = "NSE"
      @stock.exchange =  nse_exchange
      should be_valid
    end

    it "exchange format should be valid for BSE" do
      bse_exchange = "BSE"
      @stock.exchange =  bse_exchange
      should be_valid
    end
    
    it "exchange format should not be invalid for others" do
      exchanges = %w[IN TKY NYSE]
      exchanges.each do |invalid_exchange|
        @stock.exchange = invalid_exchange
        should_not be_valid
      end      
    end
  end

  describe 'should not accept blank classification' do
    before {@stock.classification= ""}
    it { should_not be_valid }
  end
  
  describe "check for classification - INVESTMENT / TRADING" do
    it "classification should be valid for INVESTMENT" do
      @stock.classification = "INVESTMENT"
      should be_valid
    end

    it "classification should be valid for TRADING" do
      @stock.classification = "TRADING"
      should be_valid
    end
    
    it "classification should be invalid for others" do
      classification = %w[IN OTHER ETC]
      classification.each do |invalid_classification|
        @stock.classification = invalid_classification
        should_not be_valid
      end      
    end
  end

  describe 'should not accept notess with > 128 characters' do
    before {@stock.notes= "a" * 129}
    it { should_not be_valid }
  end

  describe "watch parameters associations" do 
    before {@stock.save}

    let!(:param1) {FactoryGirl.create(
      :watch_parameter, symbol: @stock.symbol)}

    it 'should have all the associated watch list parameter' do
      @stock.watch_parameter == param1
    end

    it 'should destroy associated watch parameter' do
      parameter = @stock.watch_parameter.dup
      @stock.destroy
      parameter.should_not be_nil
      WatchParameter.find_by_id(parameter.id).should be_nil
    end
  end

  describe "tags associations" do 
    before {@stock.save}

    let!(:tag1) {@stock.tags.build(name: "Breakout Watch")}
    let!(:tag2) {@stock.tags.build(name: "Momentum Watch")}
     
    it 'should have all the tags ' do
      @stock.tags.length.should == 2 
      @stock.tags.should include(tag1)
      @stock.tags.should include(tag2)
    end

    it 'should destroy associated tags' do
      tags = @stock.tags.dup
      @stock.destroy
      tags.should_not be_empty
      tags.each do |tag| 
        Tag.find_by_id(tag.id).should be_nil
      end
    end
  end

  describe "stock_data associations" do 
    before {@stock.save}

    let!(:param1) {FactoryGirl.create(
      :stock_data, symbol: @stock.symbol)}

    it 'should have all the associated stock_data' do
      @stock.stock_data == param1
    end

    it 'should destroy associated stock_data ' do
      parameter = @stock.stock_data.dup
      @stock.destroy
      parameter.should_not be_nil
      StockData.find_by_id(parameter.id).should be_nil
    end
  end
  
  describe "stock classification" do
    let(:investment_stock_symbols) {["ITC","HUL","HDFC","TATAMOTORS","BAJAJ-AUTO"]}
    let(:trading_stock_symbols) {["AKZO","JP","PIPAVAV"]}

    before do
      investment_stock_symbols.each {|symbol| FactoryGirl.create(:stock_watchlist, symbol: symbol)}
      trading_stock_symbols.each {|symbol| FactoryGirl.create(:stock_watchlist_trading, symbol: symbol)}
    end

    it 'should show only investment stocks' do
      investment_stocks = StockWatchlist.search([StockWatchlist::CLASSIFICATION_INVESTMENT],nil,nil)
      investment_stocks.length.should == investment_stock_symbols.size
      investment_stocks.each {|stock| investment_stock_symbols.should include(stock.symbol)}
    end

    it 'should show only trading stocks' do
      trading_stocks = StockWatchlist.search([StockWatchlist::CLASSIFICATION_TRADING],nil,nil)
      trading_stocks.length.should == trading_stock_symbols.size
      trading_stocks.each {|stock| trading_stock_symbols.should include(stock.symbol)}
    end
  end

  describe "stock tags" do
    let(:momentum_tag_symbols) {["ITC","HUL","HDFC","TATAMOTORS","BAJAJ-AUTO"]}
    let(:breakout_tag_symbols) {["AKZO","JP","PIPAVAV"]}
    let(:momentum_tag) {"Momentum"}
    let(:breakout_tag) {"Breakout"}

    before do
      momentum_tag_symbols.each {|symbol| FactoryGirl.create(:stock_tag, name: momentum_tag, 
                                    taggable: FactoryGirl.create(:stock_watchlist, symbol: symbol))}
      breakout_tag_symbols.each {|symbol| FactoryGirl.create(:stock_tag, name: breakout_tag, 
                                    taggable: FactoryGirl.create(:stock_watchlist, symbol: symbol))}
    end

    it 'should show only specified single tag' do
      tagged_stocks = StockWatchlist.search(nil,nil,[momentum_tag])
      tagged_stocks.length.should  == momentum_tag_symbols.size
      tagged_stocks.each {|stock| momentum_tag_symbols.should include(stock.symbol)}
    end

    it 'should show only specified multiple tags' do
      tagged_stocks = StockWatchlist.search(nil,nil,[momentum_tag, breakout_tag])
      tagged_stocks.length.should == (momentum_tag_symbols.size + breakout_tag_symbols.size)
      all_tag_symbols = momentum_tag_symbols + breakout_tag_symbols
      tagged_stocks.each {|stock| all_tag_symbols.should include(stock.symbol)}
    end

    it 'should not show anthing for a wrong tag' do
      StockWatchlist.search(nil,nil,["Not Existing"]).length.should  == 0
    end
  end

  describe "stock classification & tags together" do
    let(:momentum_tag_symbols) {["ITC","HUL","HDFC","TATAMOTORS","BAJAJ-AUTO"]}
    let(:breakout_tag_symbols) {["AKZO","JP","PIPAVAV"]}
    let(:momentum_tag) {"Momentum"}
    let(:breakout_tag) {"Breakout"}

    before do
      momentum_tag_symbols.each {|symbol| FactoryGirl.create(:stock_tag, name: momentum_tag, 
                              taggable: FactoryGirl.create(:stock_watchlist, symbol: symbol))}
      breakout_tag_symbols.each {|symbol| FactoryGirl.create(:stock_tag, name: breakout_tag, 
                              taggable: FactoryGirl.create(:stock_watchlist_trading, symbol: symbol))}
    end

    it 'should show investment stocks which are tagged' do
      tagged_investment_stocks = StockWatchlist.search([StockWatchlist::CLASSIFICATION_INVESTMENT],
                                                        nil,[momentum_tag])
      tagged_investment_stocks.length.should  == momentum_tag_symbols.size
      tagged_investment_stocks.each {|stock| momentum_tag_symbols.should include(stock.symbol)}
    end

    it 'should not show investment stocks which are wrongly tagged' do
      StockWatchlist.search([StockWatchlist::CLASSIFICATION_INVESTMENT],nil,[breakout_tag]).
        length.should  == 0
    end

    it 'should show trading stocks which are tagged' do
      tagged_trading_stocks = StockWatchlist.search([StockWatchlist::CLASSIFICATION_TRADING],
                                                        nil,[breakout_tag])
      tagged_trading_stocks.length.should  == breakout_tag_symbols.size
      tagged_trading_stocks.each {|stock| breakout_tag_symbols.should include(stock.symbol)}
    end

    it 'should not show trading stocks which are wrongly tagged' do
      StockWatchlist.search([StockWatchlist::CLASSIFICATION_TRADING],nil,[momentum_tag]).
        length.should  == 0
    end
  end

  describe "stock price" do
    it "should get price for a specified stock" do
      single_stock =  "HDFC"
      exchange = "NSE"
      stock = FactoryGirl.create(:stock_watchlist, symbol: single_stock, exchange: exchange)
      
      StockWatchlist.update_price(single_stock)
      
      price = StockQuoteHelper::get_price([[single_stock, exchange]])
      StockWatchlist.find_by_symbol(single_stock).stock_data.price.should ==  price[price.keys[0]].lastTrade
    end

    it "should get price for a given list of stocks" do
      multiple_stocks = ["ITC","HINDUNILV","TATAMOTOR"]
      exchange = "NSE"
      multiple_stocks.each {|symbol| FactoryGirl.create(:stock_watchlist, symbol: symbol)}

      StockWatchlist.update_price(multiple_stocks)
      multiple_stocks.each do |symbol| 
        price = StockQuoteHelper::get_price([[symbol, exchange]])
        StockWatchlist.find_by_symbol(symbol).stock_data.price.should == price[price.keys[0]].lastTrade
      end
    end
  end
end
