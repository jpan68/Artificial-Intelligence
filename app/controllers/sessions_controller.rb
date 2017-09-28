class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    render layout: false if request.xhr? || request.env['HTTP_X_CSRF_TOKEN'].present?
  end

  def create
    errors = {}

    user = User.find_by(email: params[:email].downcase)
    if user.present? && user.authenticate(params[:password])
      log_in user

      if params[:remember_me].present?
        params[:remember_me] == '1' ? remember(user) : forget(user)
      end

      if request.xhr? || request.env['HTTP_X_CSRF_TOKEN'].present?
        render json: { redirect_url: videos_path }
      else
        redirect_to videos_path
      end
    # Throws error messages if not authenticated
    else
      if params[:email].empty? || params[:password].empty?
        errors["field-wrapper"] = "Email or password is empty. Please try again."
      else
        errors["field-wrapper"] = "Your email or password is not valid. Please try again."
      end

      if request.xhr? || request.env['HTTP_X_CSRF_TOKEN'].present?
        render json: { errors: errors }, status: :forbidden
      else
        flash[:errors] = errors
        redirect_to login_path
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to params[:redirect_url] || root_path
  end

end
