class ApplicationController < ActionController::Base
  before_action :set_locale
  helper_method :current_user, :signed_in?

  private

  def set_locale
    locale = params[:locale] || session[:locale] || I18n.default_locale
    locale = locale.to_sym
    if I18n.available_locales.include?(locale)
      I18n.locale = locale
      session[:locale] = locale
    end
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  def current_user
    return @current_user if defined?(@current_user)
    token = cookies[:remember_token]
    @current_user = token.present? ? User.find_by(remember_token: User.encrypt(token)) : nil
  end

  def signed_in?
    !current_user.nil?
  end

  def authenticate_user!
    redirect_to signin_path, alert: t("users.invalid") unless signed_in?
  end
end