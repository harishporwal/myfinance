require 'spec_helper'

describe StockWatchlist do
  before { @stock = StockWatchlist.new(symbol: "ITC", exchange: "NSE", 
                                       classification: "INVESTMENT", notes: "Leadership Stock")}

  subject { @stock}

  it { should respond_to(:symbol) }
  it { should respond_to(:exchange) }
  it { should respond_to(:classification) }
  it { should respond_to(:notes) }

  it { should respond_to(:watch_parameters) }

  it { should be_valid }

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

    let!(:watch_50_ema) {FactoryGirl.create(
      :watch_parameter_ema_50, symbol: @stock.symbol)}
    let!(:watch_100_ema) {FactoryGirl.create(
      :watch_parameter_ema_100, symbol: @stock.symbol)}
    let!(:watch_200_ema) {FactoryGirl.create(
      :watch_parameter_ema_200, symbol: @stock.symbol)}
    let!(:watch_breakout_level) {FactoryGirl.create(
      :watch_parameter_breakout_level, symbol: @stock.symbol)}
    let!(:watch_resistance_level) {FactoryGirl.create(
      :watch_parameter_resistance_level, symbol: @stock.symbol)}
    let!(:watch_price) {FactoryGirl.create(
      :watch_parameter_price, symbol: @stock.symbol)}
      

    it 'should have all the watch list parameters' do
      @stock.watch_parameters.should include(watch_50_ema)
      @stock.watch_parameters.should include(watch_100_ema)
      @stock.watch_parameters.should include(watch_200_ema)
      @stock.watch_parameters.should include(watch_breakout_level)
      @stock.watch_parameters.should include(watch_resistance_level)
      @stock.watch_parameters.should include(watch_price)
    end

    it 'should destroy associated watch parameters' do
      watch_parameters = @stock.watch_parameters.dup
      @stock.destroy
      watch_parameters.should_not be_empty
      watch_parameters.each do |parameter| 
        WatchParameter.find_by_id(parameter.id).should be_nil
      end
    end
  end

  describe "tags associations" do 
    before {@stock.save}

    let!(:tag1) {@stock.tags.build(name: "Breakout Watch")}
    let!(:tag2) {@stock.tags.build(name: "Momentum Watch")}
     
    it 'should have all the tags ' do
      @stock.tags.count == 2 
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
end
