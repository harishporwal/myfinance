require 'spec_helper'

describe WatchParameter do
  let(:stock_watchlist) {FactoryGirl.create(:stock_watchlist)}
  before do
    @watch_parameter = stock_watchlist.watch_parameters.build(
      name: WatchParameter::EMA_50, watch_level: 100)
  end
  
  subject { @watch_parameter}

  it { should respond_to(:symbol) }
  it { should respond_to(:name) }
  it { should respond_to(:watch_level) }
  it { should respond_to(:stock_watchlist) }

  it { should be_valid }

  describe 'should not accept blank name' do
    before {@watch_parameter.name= ""}
    it { should_not be_valid }
  end

  describe "should not accept duplicate name" do
    before do
      @watch_parameter.save
    end
    let (:another_watch_parameter) {stock_watchlist.watch_parameters.build(
      name: stock_watchlist.watch_parameters.all(limit:1).first().name, 
      watch_level: 200)}

    subject {another_watch_parameter}
    it {should_not be_valid}
  end
 
  describe "check for parameter names - should be from the possible list" do
    it "parameter should be valid from this list " do
      parameters = WatchParameter::ALL_PARAMETERS
      parameters.each do |parameter|
        @watch_parameter.name =  parameter
        should be_valid
      end
    end

    it "parameter name should not be invalid for others" do
      parameters = ["My Support", "Next Support", "etc"]
      parameters.each do |parameter|
        @watch_parameter.name =  parameter
        should_not be_valid
      end
    end
  end

  describe "check for parameter watch_level " do
    it "should be blank " do
      parameters = WatchParameter::AUTO_PARAMETERS
      parameters.each do |parameter|
        @watch_parameter.name =  parameter
        @watch_parameter.watch_level =  nil
        should be_valid
      end
    end

    it "should not be blank" do
      parameters =  WatchParameter::ALL_PARAMETERS - WatchParameter::AUTO_PARAMETERS
      parameters.each do |parameter|
        @watch_parameter.name =  parameter
        @watch_parameter.watch_level =  nil
        should_not be_valid
      end
    end
  end
end
