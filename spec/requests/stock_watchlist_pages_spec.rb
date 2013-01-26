require 'spec_helper'

describe "StockWatchlistPages" do
  let(:user) {FactoryGirl.create(:user)}
  let(:base_title) {'MyFinance'}
  subject {page}

  describe "add stock page" do
    before do
      sign_in user
      visit new_stock_watchlist_path
    end
    let (:submit) {"Add Stock"}    

    it {should have_selector('title', text: "#{base_title} | Add Stock to Watchlist")}
    it {should have_selector('h1', text: 'Add Stock to Watchlist')}
    it {should have_selector('legend', text: "Basic Stock Details")}
    it {should have_selector('legend', text: "Watch Parameters")}
    it {should have_selector('legend', text: "Stock Tags")}


    it "should not create account, with empty data" do
      expect {click_button submit}.not_to change(StockWatchlist, :count)
    end

    it "should create account, with valid data" do
      fill_in "Symbol", with: "ITC"
      select "NSE", from: "Exchange"
      select "INVESTMENT", from: "Classification"
      fill_in "Notes", with: "Investment Stock"

      check "50 day"
      check "100 day"
      check "200 day"
      fill_in "Resistance", with: 200
      fill_in "Breakout", with: 300
      fill_in "Price", with: 400

      fill_in "stock_watchlist_tags_attributes_0_name", with: "Breakout Watch"
      fill_in "stock_watchlist_tags_attributes_1_name", with: "Momentum Push"

      expect {click_button submit}.to change(StockWatchlist, :count).by(1) && 
                                      change(WatchParameter, :count).by(1) && 
                                      change(Tag, :count).by(2)
      should have_link('Sign out')
    end    
  end

  describe 'edit stock page' do 
    let!(:stock_watchlist) {FactoryGirl.create(:stock_watchlist)}
    before do 
      stock_watchlist.tags.create(name: "Breakout Watch")
      stock_watchlist.tags.create(name: "Momentum Watch")
      stock_watchlist.tags.create(name: "Turnaround")
      sign_in user
      visit edit_stock_watchlist_path(stock_watchlist.symbol)
    end

    describe 'page' do 
      it {should have_selector('title', text: "#{base_title} | Edit Stock from Watchlist")}
      it {should have_selector('h1', text: "Edit Stock - #{stock_watchlist.symbol}")}
      it {should have_selector('legend', text: "Basic Stock Details")}
      it {should have_selector('legend', text: "Watch Parameters")}
      it {should have_selector('legend', text: "Stock Tags")}
    end

    describe 'with valid information' do
      let(:new_symbol) {'New Symbol'}
      let(:new_exchange) {'BSE'}
      let(:new_classification) {'TRADING'}
      
      let(:new_resistance) {500}
      let(:new_breakout) {600}
      let(:new_price) {700}
      
      let(:new_tag1) {'New Tag1'}
      let(:new_tag2) {'New Tag2'}

      before do
        select "BSE", from: "Exchange"
        select "TRADING", from: "Classification"

        uncheck "50 day"
        uncheck "100 day"
        uncheck "200 day"
        fill_in "Resistance", with: new_resistance
        fill_in "Breakout", with: new_breakout
        fill_in "Price", with: new_price
        fill_in "stock_watchlist_tags_attributes_0_name", with: new_tag1
        fill_in "stock_watchlist_tags_attributes_1_name", with: new_tag2
        check "stock_watchlist_tags_attributes_2__destroy"
        click_button 'Save Changes'
      end

      it {should have_selector('div.alert.alert-success')}

      specify {stock_watchlist.reload.symbol == new_symbol}
      specify {stock_watchlist.reload.exchange == new_exchange}
      specify {stock_watchlist.reload.classification == new_classification}
      specify {stock_watchlist.watch_parameter.reload.resistance == new_resistance}
      specify {stock_watchlist.watch_parameter.reload.breakout== new_breakout}
      specify {stock_watchlist.watch_parameter.reload.price== new_price}
      specify {stock_watchlist.watch_parameter.reload.ma_50 == 0}
      specify {stock_watchlist.watch_parameter.reload.ma_100 == 0}
      specify {stock_watchlist.watch_parameter.reload.ma_200 == 0}

      specify {stock_watchlist.tags.reload.count == 2}
      specify {stock_watchlist.tags.reload.first.name == new_tag1}
      specify {stock_watchlist.tags.reload.last.name == new_tag2}
    end
  end

  describe 'index' do
    before do
      sign_in user
      FactoryGirl.create(:stock_watchlist, symbol: 'TATAGLOBAL', notes: 'Stock for this year')
      FactoryGirl.create(:stock_watchlist, symbol: 'COMPUSOFT', classification: 'TRADING',
                         notes: 'Speculative Stock')
      visit stock_watchlists_path
    end

    describe "page" do
      it { should have_selector('h1', :text => 'Stocks in Watchlist') }
      it { should have_selector('title', :text => "#{base_title} | Stocks in Watchlist") }

      it "should list each stock" do
        StockWatchlist.all.each do |stock_watchlist|
          page.should have_link("#{stock_watchlist.symbol}", 
                                href: edit_stock_watchlist_path(stock_watchlist.symbol))
        end
      end
    end

    describe 'pagination' do
      before(:all) {30.times {FactoryGirl.create(:stock_watchlist)}}
      after(:all) {StockWatchlist.delete_all}

      it {should have_selector('div.pagination')}
      it "should list all stocks" do
        StockWatchlist.paginate(page: 1) do |stock_watchlist|
          page.should have_link("#{stock_watchlist.symbol}", 
                                href: edit_stock_watchlist_path(stock_watchlist.symbol))
        end
      end
    end

    describe 'delete stock_watchlist' do
      let!(:stock_watchlist) {FactoryGirl.create(:stock_watchlist)}
      let!(:tag1) {stock_watchlist.tags.create(name: "Breakout Watch")}
      let!(:tag2) {stock_watchlist.tags.create(name: "Momentum Watch")}
      let!(:tag3) {stock_watchlist.tags.create(name: "Turnaround")}
      
      before do
        sign_in user
        visit stock_watchlists_path
      end

      it {should have_link('Delete', href: stock_watchlist_path(stock_watchlist))}
      it "should be able to delete stock" do
        expect {click_link('Delete')}.to change(StockWatchlist, :count).by(-1) && 
                  change(WatchParameter, :count).by(-1) &&
                  change(Tag, :count).by(-3)
      end
    end
  end
end
