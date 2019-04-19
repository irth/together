module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def save_spotify_credentials(credentials)
    session[:spotify] = credentials
    cookies.permanent.encrypted[:spotify] = credentials.to_json
  end

  def remember(user)
    t = AuthToken.new
    t.user = user
    t.save

    cookies.permanent[:token] = t.token
  end

  def current_user
    # force the user to log in again if they don't have their spotify credentials stored
    if !session[:spotify]
      log_out
      return
    end

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

  def spotify_credentials
    if (credentials = session[:spotify])
      @credentials ||= credentials
    elsif (credentials = JSON.parse(cookies.encrypted[:spotify]))
      save_spotify_credentials credentials
      @credentials ||= credentials
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)

    AuthToken.find_by(token: cookies[:token])&.destroy
    cookies.delete(:token)

    session.delete(:spotify)
    cookies.delete(:spotify)

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
