class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :settings]
  before_filter :correct_user, only: [:show, :settings] 

  def show
    @user = User.find(params[:id])
  end

  def settings
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(params[:user])
    if @user.save 
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  
end
