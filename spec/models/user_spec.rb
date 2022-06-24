# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new }

  describe 'associations' do
    it { is_expected.to have_many(:boards) }
    it { is_expected.to have_many(:imports) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_size_of(:avatar) }
    it { is_expected.to validate_content_type_of(:avatar).allowing('image/jpeg', 'image/png', 'image/gif') }
  end
end
