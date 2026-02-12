# frozen_string_literal: true

class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :title, null: false
      t.text :description, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :requests, %i[user_id created_at]
  end
end
