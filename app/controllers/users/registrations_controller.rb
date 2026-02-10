class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super do |resource|
      render json: { user: { id: resource.id, email: resource.email } }, status: :created and return if resource.persisted?
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
