class ApplicationController < ActionController::Base
  include SessionsHelper
  include ApplicationHelper

  def logged_in_user
    _logged_in_user false
  end

  def logged_in_user_force_redirect
    _logged_in_user true
  end

  private

  def _logged_in_user(force)
    unless logged_in?
      store_location force
      redirect_to full_url_for auth_path(:spotify)
    end
  end
end
