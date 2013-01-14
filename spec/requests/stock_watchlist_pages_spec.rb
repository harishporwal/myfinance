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


    it "should not create account, with empty data" do
      expect {click_button submit}.not_to change(StockWatchlist, :count)
    end

    it "should create account, with valid data" do
      fill_in "Symbol", with: "ITC"
      select "NSE", from: "Exchange"
      select "INVESTMENT", from: "Classification"
      fill_in "Notes", with: "Investment Stock"

      expect {click_button submit}.to change(StockWatchlist, :count).by(1)
      should have_link('Sign out')
    end    
  end

  describe 'edit stock page' do 
    let(:stock_watchlist) {FactoryGirl.create(:stock_watchlist)}
    before do 
      sign_in user
      visit edit_stock_watchlist_path(stock_watchlist.symbol)
    end

    describe 'page' do 
      it {should have_selector('title', text: "#{base_title} | Edit Stock from Watchlist")}
      it {should have_selector('h1', text: "Edit Stock - #{stock_watchlist.symbol}")}
    end

    describe 'with invalid information' do
      before do 
        fill_in "Symbol", with: ""
        click_button 'Save Changes'
      end

      it {should have_content('error')}
    end

    describe 'with valid information' do
      let(:new_symbol) {'New Symbol'}
      let(:new_exchange) {'BSE'}
      let(:new_classification) {'TRADING'}

      before do
        fill_in "Symbol", with:new_symbol
        select "BSE", from: "Exchange"
        select "TRADING", from: "Classification"

        click_button 'Save Changes'
      end

      it {should have_selector('div.alert.alert-success')}

      specify {stock_watchlist.reload.symbol == new_symbol}
      specify {stock_watchlist.reload.exchange == new_exchange}
      specify {stock_watchlist.reload.classification == new_classification}
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
      let(:stock_watchlist) {FactoryGirl.create(:admin)}
      before do
        sign_in user
        visit stock_watchlists_path
      end

      it {should have_link('Delete', href: stock_watchlist_path(StockWatchlist.first))}
      it "should be able to delete stock" do
        expect {click_link('Delete')}.to change(StockWatchlist, :count).by(-1)
      end
    end
  end
end
