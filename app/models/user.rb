# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :requests, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  def ensure_auth_token!
    update!(auth_token: generate_unique_token) if auth_token.blank?
    auth_token
  end

  private

  def generate_unique_token
    loop do
      token = SecureRandom.hex(20)
      break token unless User.exists?(auth_token: token)
    end
  end
end
