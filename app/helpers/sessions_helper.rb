module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    t = AuthToken.new
    t.user = user
    t.save

    cookies.permanent[:token] = t.token
  end

  def current_user
    if (user_id = session[:user_id])
      # if possible, load the user from session
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (token = cookies[:token])
      # alternatively, use cookies
      token = AuthToken.find_by(token: token)
      if token
        if token.expires_at.past?
          log_out # delete the cookies and session data
        else
          token.refresh
          log_in token.user
          @current_user = token.user
        end
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)

    AuthToken.find_by(token: cookies[:token])&.destroy
    cookies.delete(:token)

    @current_user = nil
  end

  def store_location(force = false)
    session[:forwarding_url] = request.original_url if request.get? || force
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
