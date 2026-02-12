class GuestAuthController < ApplicationController
  def login
    guest_email = 'guest@example.com'
    user = User.find_or_initialize_by(email: guest_email)

    if user.new_record?
      pw = SecureRandom.hex(16)
      user.password = pw
      user.password_confirmation = pw
      user.save!
    end

    token = user.ensure_auth_token!
    response.headers['Authorization'] = "Bearer #{token}"
    render json: { user: { id: user.id, email: user.email, auth_token: token } }, status: :ok
  end
end
