class AuthController < ApplicationController
  def create
    user = User.find_by(email: params.dig(:user, :email))
    if user&.authenticate(params.dig(:user, :password))
      render json: { user: { id: user.id, email: user.email, auth_token: user.auth_token } }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def guest
    guest_email = 'guest@example.com'
    user = User.find_or_initialize_by(email: guest_email)
    if user.new_record?
      pw = SecureRandom.hex(16)
      user.password = pw
      user.password_confirmation = pw
      user.save!
    elsif user.auth_token.blank?
      user.update!(auth_token: SecureRandom.hex(20))
    end

    render json: { user: { id: user.id, email: user.email, auth_token: user.auth_token } }
  end
end
