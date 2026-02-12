# frozen_string_literal: true

class AddPriorityToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :priority, :integer, null: false, default: 0
  end
end
