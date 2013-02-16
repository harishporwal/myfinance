require 'spec_helper'
require 'ruby-debug'

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
      3.times {FactoryGirl.create(:stock_tag, taggable: stock_watchlist)}
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
    describe "page" do
      before do
        sign_in user
        FactoryGirl.create(:stock_watchlist, symbol: 'TATAGLOBAL', notes: 'Stock for this year')
        FactoryGirl.create(:stock_watchlist, symbol: 'COMPUSOFT', classification: 'TRADING',
                           notes: 'Speculative Stock')
        visit stock_watchlists_path
      end
      
      it { should have_selector('h1', :text => 'Stocks in Watchlist') }
      it { should have_selector('title', :text => "#{base_title} | Stocks in Watchlist") }

      describe 'filter criteria in page' do
        before do
          FactoryGirl.create(:stock_tag, name: "Tag1", taggable: FactoryGirl.create(:stock_watchlist))
          FactoryGirl.create(:stock_tag, name: "Tag2", taggable: FactoryGirl.create(:stock_watchlist))
          FactoryGirl.create(:stock_tag, name: "Tag3", taggable: FactoryGirl.create(:stock_watchlist))

          visit stock_watchlists_path
        end
        it {should have_selector('legend', text: "Choose Filter Criteria")}

        it "should have filter for classification" do
          page.should have_selector('input', name: 'filter_investment')
          page.should have_selector('input', name: 'filter_trading')
        end

        it "should have filter for watch parameters" do
          page.should have_selector('input', name: 'filter_50_ema')
          page.should have_selector('input', name: 'filter_100_ema')
          page.should have_selector('input', name: 'filter_200_ema')
          page.should have_selector('input', name: 'filter_resistance')
          page.should have_selector('input', name: 'filter_breakout')
          page.should have_selector('input', name: 'filter_price')
        end

        it "should have filter for tags" do
          Tag.unique_stock_tags.each { |tag| page.should have_selector("option", text:tag.name) } 
        end
      end
      
      it "should list each stock" do
        StockWatchlist.all.each do |stock_watchlist|
          page.should have_link("#{stock_watchlist.symbol}", 
                                href: edit_stock_watchlist_path(stock_watchlist.symbol))
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
    end

    describe 'delete stock_watchlist' do
      let!(:stock_watchlist) {FactoryGirl.create(:stock_watchlist)}

      before do
        FactoryGirl.create(:stock_tag, taggable: stock_watchlist)
        sign_in user
        visit stock_watchlists_path
      end

      it {should have_button('Delete')}
      it "should be able to delete stock" do
        expect {click_button('Delete')}.to change(StockWatchlist, :count).by(-1) && 
                  change(WatchParameter, :count).by(-1) #&& change(Tag, :count).by(-1)
      end
    end

    describe "filter criteria" do
      let(:investment_symbols) {["ITC","HUL","HDFC","TATAMOTORS","BAJAJ-AUTO"]}
      let(:trading_symbols) {["AKZO","JP","PIPAVAV"]}
      let(:other_symbols) {["SYM1","SYM2"]}

      let(:tag1_symbols) {investment_symbols}
      let(:tag2_symbols) {trading_symbols}
      let(:tag3_symbols) {other_symbols}
      
      let(:tag1) {"Tag1"}
      let(:tag2) {"Tag2"}
      let(:tag3) {"Tag3"}

      before  do
        investment_symbols.each {|symbol| FactoryGirl.create(:stock_tag, name: tag1, 
                                    taggable: FactoryGirl.create(:stock_watchlist, symbol: symbol))}
        trading_symbols.each {|symbol| FactoryGirl.create(:stock_tag, name: tag2, taggable: 
                                    FactoryGirl.create(:stock_watchlist_trading, symbol: symbol))}
        other_symbols.each {|symbol| FactoryGirl.create(:stock_tag, name: tag3, taggable: 
                                    FactoryGirl.create(:stock_watchlist, symbol: symbol))}
        sign_in user
        visit stock_watchlists_path
      end
      after {StockWatchlist.delete_all}


      it "without selection, should list all stocks" do
        (investment_symbols + trading_symbols + other_symbols).each {|symbol|
          should have_link("#{symbol}", href: edit_stock_watchlist_path(symbol))}

        page.find('#filter_investment').should_not be_checked
        page.find('#filter_trading').should_not be_checked
      end

        
      describe "for classification" do
        it "should list only investment stocks - ajax call" do
          xml_http_request :get, '/stock_watchlists', filter_investment: "INVESTMENT"
          
          (investment_symbols + other_symbols).each  { |symbol| response.body.should include("#{symbol}")}
          (trading_symbols).each { |symbol| response.body.should_not include("#{symbol}")}
        end

        it "should list only trading stocks" do
          xml_http_request :get, '/stock_watchlists', filter_trading: "TRADING"
          
          (trading_symbols).each { |symbol| response.body.should include("#{symbol}")}
          (investment_symbols + other_symbols).each  { |symbol| 
            response.body.should_not include("#{symbol}")}
        end

           
        it "should list both trading & investment stocks" do
          xml_http_request :get, '/stock_watchlists', filter_investment: "INVESTMENT", 
            filter_trading:"TRADING"
          
          (investment_symbols + trading_symbols + other_symbols).each  { |symbol| 
            response.body.should include("#{symbol}")}
        end
      end

      describe "for tags" do
        it "should list only selected tag stocks -single selection" do
          xml_http_request :get, '/stock_watchlists', filter_tags: ["Tag1"] 
          
          (tag1_symbols).each  {|symbol| response.body.should include("#{symbol}")}
          (tag2_symbols+tag3_symbols).each { |symbol| response.body.should_not include("#{symbol}")}
        end

        it "should list only selected tag stocks -multiple selection" do
          xml_http_request :get, '/stock_watchlists', filter_tags: ["Tag1","Tag2"] 

          (tag1_symbols + tag2_symbols).each  {|symbol| response.body.should include("#{symbol}")}
          (tag3_symbols).each { |symbol| response.body.should_not include("#{symbol}")}
        end
      end

      describe "for combination of classification & tags" do
        it "should list investment and tagged stocks" do
          xml_http_request :get, '/stock_watchlists', filter_investment: "INVESTMENT", 
            filter_tags: ["Tag1"] 
          
          (investment_symbols & tag1_symbols).each  {|symbol|
            response.body.should include("#{symbol}")}
 
          (trading_symbols).each  {|symbol|
            response.body.should_not include("#{symbol}")}
 
          (tag2_symbols + tag3_symbols).each  {|symbol|
            response.body.should_not include("#{symbol}")}
        end

        it "should list both investment & trading - tagged stocks" do
          xml_http_request :get, '/stock_watchlists', filter_investment: "INVESTMENT", 
            filter_trading: "TRADING", filter_tags: ["Tag2"] 
          
          (investment_symbols & tag2_symbols).each {|symbol|
            response.body.should include("#{symbol}")}

          (trading_symbols & tag2_symbols).each {|symbol|
            response.body.should include("#{symbol}")}

          (tag1_symbols + tag3_symbols).each {|symbol|
            response.body.should_not include("#{symbol}")}
        end

       it "should list both investment & trading - multiple tagged stocks" do
          xml_http_request :get, '/stock_watchlists', filter_investment: "INVESTMENT", 
            filter_trading: "TRADING", filter_tags: ["Tag1","""Tag2"] 
          
          (investment_symbols & (tag1_symbols + tag2_symbols)).each {|symbol|
            response.body.should include("#{symbol}")}
          (trading_symbols & (tag1_symbols + tag2_symbols)).each {|symbol|
            response.body.should include("#{symbol}")}

          (tag3_symbols).each {|symbol|
            response.body.should_not include("#{symbol}")}
       end
      end
    end
  end
end
