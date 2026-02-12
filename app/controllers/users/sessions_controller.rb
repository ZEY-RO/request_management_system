# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      super do |resource|
        if resource.persisted?
          token = resource.ensure_auth_token!
          response.headers['Authorization'] = "Bearer #{token}"
          render json: { user: { id: resource.id, email: resource.email, auth_token: token } }, status: :ok and return
        end
      end
    end
  end
end
