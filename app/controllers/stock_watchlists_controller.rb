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
    redirect_to stock_watchlists_path
  end

  def index
    @stock_tags ||= Tag.unique_stock_tags
    @filter_investment = params[:filter_investment]
    @filter_trading = params[:filter_trading]
    @filter_tags = params[:filter_tags]

    if ((@filter_investment ==  @filter_trading) && 
        (@filter_tags == nil || @filter_tags.length == @stock_tags.length))
      @stock_watchlists = StockWatchlist.paginate(page: params[:page])
    elsif (!@filter_tags)
      @stock_watchlists = (@filter_investment ? StockWatchlist.investment_stocks :
                           StockWatchlist.trading_stocks).paginate(page: params[:page])
    elsif (@filter_tags)
      @stock_watchlists = StockWatchlist.tagged_stocks(@filter_tags).paginate(page: params[:page])
    else
      @stock_watchlists = (@filter_investment ? StockWatchlist.tagged_investment_stocks(@filter_tags):
                     StockWatchlist.tagged_trading_stocks(@filter_tags)).paginate(page: params[:page])
    end
  end
end
