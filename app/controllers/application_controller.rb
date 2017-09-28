class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  helper_method :correct_user
  before_action :clear_browser_cache
  before_action :set_current_user

  def clear_browser_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def login_check
    @current_user = nil
    if !session[:user_id].nil?
      @current_user = User.find(session[:user_id])
    else
      redirect_to login_path
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:error] = t('alert.errors.login_user_only')
      redirect_to login_path
    end
  end

  def correct_user(user_id)
    user_id != session[:user_id] ? false : true
  end

  private

    def set_current_user
      @current_user = current_user
    end

end
