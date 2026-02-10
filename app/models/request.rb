class Request < ApplicationRecord
  enum status: { pending: 0, approved: 1, rejected: 2 }

  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
end
