# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, approved: 1, rejected: 2) }
    it { should define_enum_for(:priority).with_values(low: 0, medium: 1, high: 2) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:priority) }
  end

  describe 'default values' do
    it 'has default status of pending' do
      request = Request.create!(title: 'Test', description: 'Test desc', user:)
      expect(request.status).to eq('pending')
    end

    it 'has default priority of medium' do
      request = Request.create!(title: 'Test', description: 'Test desc', user:)
      expect(request.priority).to eq('low')
    end
  end

  describe 'creating a valid request' do
    it 'is valid with all required attributes' do
      request = Request.new(title: 'Test Request', description: 'Description', status: :pending, priority: :high,
                            user:)
      expect(request).to be_valid
    end

    it 'is invalid without title' do
      request = Request.new(description: 'Description', status: :pending, priority: :high, user:)
      expect(request).not_to be_valid
      expect(request.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without description' do
      request = Request.new(title: 'Test', status: :pending, priority: :high, user:)
      expect(request).not_to be_valid
      expect(request.errors[:description]).to include("can't be blank")
    end

    it 'is invalid with invalid status' do
      expect do
        Request.new(title: 'Test', description: 'Desc', status: :invalid, priority: :high,
                    user:)
      end.to raise_error(ArgumentError)
    end

    it 'is invalid with invalid priority' do
      expect do
        Request.new(title: 'Test', description: 'Desc', status: :pending, priority: :invalid,
                    user:)
      end.to raise_error(ArgumentError)
    end
  end
end
