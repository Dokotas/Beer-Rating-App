class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def new
    redirect_to root_path and return if signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in_user(@user)
      redirect_to root_path, notice: t("users.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @total = @user.values.count

    # Оценки, отличающиеся не более чем на 25% от среднего по картинке
    @close_values = @user.values.includes(:image).select do |v|
      avg = v.image.ave_value.to_f
      avg.positive? && (v.value - avg).abs / avg <= 0.25
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def sign_in_user(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_column(:remember_token, User.encrypt(remember_token))
  end
end