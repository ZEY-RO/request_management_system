class AuthController < ApplicationController
  def guest
    guest_email = 'guest@example.com'
    user = User.find_or_initialize_by(email: guest_email)

    if user.new_record?
      pw = SecureRandom.hex(16)
      user.password = pw
      user.password_confirmation = pw
      user.save!
    end

    render json: { user: { id: user.id, email: user.email } }, status: :ok
  end
end
