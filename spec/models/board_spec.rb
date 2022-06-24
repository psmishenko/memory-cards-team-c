# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  subject(:board) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:cards) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }

    it { expect(board).to validate_length_of(:name).is_at_least(2) }

    it { expect(board).to validate_length_of(:description).is_at_most(200) }
  end
end
