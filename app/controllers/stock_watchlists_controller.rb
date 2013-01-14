class StockWatchlistsController < ApplicationController
  before_filter :signed_in_user

  def new
    @stock_watchlist = StockWatchlist.new
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
    @stock_watchlists = StockWatchlist.paginate(page: params[:page])
  end
end
