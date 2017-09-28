class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :set_user, except: [:new, :create]
  before_action :correct_user, except: [:new]

  def new
    @user = User.new
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    @user = User.new(user_params)
    redirect_url = params[:redirect_url].present? ? params[:redirect_url] : root_path

    if @user.save
      log_in @user
      if request.xhr? || request.env['HTTP_X_CSRF_TOKEN'].present?
        render json: { redirect_url: root_path }
      else
        redirect_to root_path
      end
    else
      errors = {}
      @user.errors.each do |key, value|
        message = "#{key.to_s.capitalize.humanize} #{value}"
        flash[key] = errors[key] = "#{message}"
      end

      if request.xhr? || request.env['HTTP_X_CSRF_TOKEN'].present?
        render json: { errors: errors }, status: :forbidden
      else
        redirect_to signup_path
      end
    end
  end

  def edit
  end

  def update
    if params[:user].present? && @user.update(user_params)
      redirect_to root_path
    else
      flash[:errors] = {}
      @user.errors.each do |key, value|
        message = "#{key.to_s.capitalize.humanize} #{value}"
        flash[:errors] = { key => "#{message}" }
      end

      if request.xhr? || request.env['HTTP_X_CSRF_TOKEN'].present?
        render json: { errors: errors }, status: :forbidden
      else
        redirect_to edit_user_path
      end
    end
  end

  def destroy
    User.find(params[:user_id]).destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_password
  end

  def update_password
    if params[:user].present? && @user.update(user_params)
      redirect_to root_path
    else
      flash[:errors] = {}
      @user.errors.each do |key, value|
        message = "#{key.to_s.capitalize.humanize} #{value}"
        flash[:errors] = { key => "#{message}" }
      end
      redirect_to edit_password_user_path
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def correct_user
      redirect_to root_url unless current_user?(@user)
    end

    def user_params
      params.require(:user).permit(
        :first_name, :last_name, :email,
        :password, :password_confirmation,
      )
    end

end
