class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |resource|
      render json: { user: { id: resource.id, email: resource.email } }, status: :ok and return if resource.persisted?
    end
  end
end
