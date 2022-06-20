# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
  subject(:card) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:board) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:question) }
    it { is_expected.to validate_presence_of(:answer) }

    it {
      expect(card).to validate_length_of(:question).is_at_most(200)
    }

    it {
      expect(card).to define_enum_for(:confidence_level)
        .with_values(%i[undefined very_bad bad medium good perfect])
    }
  end
end
