class SessionsController < ApplicationController
  before_action :is_banned, only:[:create]

  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end

  def is_banned
    user = User.find_by username: params[:username]
    if user.banned
      redirect_to signin_path, notice:'Your account is frozen, please contact admin'
    end
  end
end