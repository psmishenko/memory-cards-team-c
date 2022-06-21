# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import, type: :model do
  subject(:import) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'relations' do
    it { is_expected.to have_one_attached(:file) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:file) }
    it { is_expected.to validate_size_of(:file).less_than(10.megabytes) }
  end
end
