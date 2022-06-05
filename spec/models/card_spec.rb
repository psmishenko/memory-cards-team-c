# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
  subject(:card) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:board) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:question).with_message('Question is required') }
    it { is_expected.to validate_presence_of(:answer).with_message('Answer is required') }

    it {
      expect(card)
        .to validate_length_of(:question)
        .is_at_most(200).with_message('200 characters is the maximum allowed')
    }
  end
end
