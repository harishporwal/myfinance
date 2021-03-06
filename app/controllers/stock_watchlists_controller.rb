class StockWatchlistsController < ApplicationController
  before_filter :signed_in_user

  def new
    @stock_watchlist = StockWatchlist.new
    @stock_watchlist.build_watch_parameter
    3.times {@stock_watchlist.tags.build}
  end

  def create 
    @stock_watchlist = StockWatchlist.new(params[:stock_watchlist])
    if @stock_watchlist.save 
      flash[:success] = "Stock #{@stock_watchlist.symbol} added successfully"
      redirect_to stock_watchlists_path
    else
      render 'new'
    end
  end

  def edit
    @stock_watchlist = StockWatchlist.find_by_symbol(params[:id])
  end

  def update 
    @stock_watchlist = StockWatchlist.find(params[:id])
    if @stock_watchlist.update_attributes(params[:stock_watchlist])
      flash[:success] = "Stock #{@stock_watchlist.symbol} updated successfully"
      redirect_to stock_watchlists_path
    else
      render 'edit'
    end
  end
  
  def show
    @stock_watchlist = StockWatchlist.find_by_symbol(params[:id])
  end

  def destroy
    StockWatchlist.find(params[:id]).destroy
    flash[:success] = "Stock removed successfully"


    respond_to do |format|
      format.html {redirect_to stock_watchlists_path}
      format.js {@stock_watchlists = search_stocks}
    end
  end

  def index
    @stock_tags ||= Tag.unique_stock_tags
    @stock_watchlists = search_stocks

    respond_to do |format|
      format.html       
      format.js
    end
  end

  private
    def search_stocks
      @filter_investment = params[:filter_investment]
      @filter_trading = params[:filter_trading]
      @filter_tags = params[:filter_tags]


      filter_classification = [@filter_investment, @filter_trading]
      StockWatchlist.search(filter_classification.delete_if{|x| x == nil},
                                      nil,@filter_tags).paginate(page: params[:page], per_page: 25)
    end
end
