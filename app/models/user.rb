class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :requests, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  def ensure_auth_token!
    if auth_token.blank?
      update!(auth_token: generate_unique_token)
    end
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
