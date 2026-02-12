# frozen_string_literal: true

class Request < ApplicationRecord
  enum status: { pending: 0, approved: 1, rejected: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :priority, presence: true, inclusion: { in: priorities.keys }
end
