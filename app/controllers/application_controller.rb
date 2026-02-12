# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_from_token

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
  end

  private

  # Allow stateless auth for API clients (e.g., React) via:
  # Authorization: Bearer <auth_token>
  def authenticate_user_from_token
    return if devise_controller?

    header = request.headers['Authorization'].to_s
    return if header.blank?

    token = header.split.last
    return if token.blank?

    user = User.find_by(auth_token: token)
    sign_in(user, store: false) if user
  end

  # Devise's default `authenticate_user!` redirects for HTML apps.
  # For this JSON API, return a 401 instead.
  def authenticate_user!
    return super if devise_controller?

    authenticate_user_from_token
    return if current_user.present?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
