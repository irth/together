class SessionsController < ApplicationController
  def spotify
    @user = User.find_or_create_by_omniauth request.env['omniauth.auth']

    if @user
      log_in @user
      redirect_back_or root_url
    else
      raise 'find_or_create_by_spotify failed'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
