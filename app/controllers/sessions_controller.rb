class SessionsController < ApplicationController
  def new
    redirect_to root_path and return if signed_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].to_s.downcase)
    if user&.authenticate(params[:session][:password])
      remember_token = User.new_remember_token
      cookies.permanent[:remember_token] = remember_token
      user.update_column(:remember_token, User.encrypt(remember_token))
      redirect_to root_path, notice: t("nav.hello", name: user.name)
    else
      flash.now[:alert] = t("users.invalid")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user
      current_user.update_column(:remember_token, User.encrypt(User.new_remember_token))
    end
    cookies.delete(:remember_token)
    redirect_to root_path, notice: t("users.signed_out")
  end
end