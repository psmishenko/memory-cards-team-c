# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :board
  validates :question, presence: { message: 'is required' },
                       length: { maximum: 200, message: '%<count>s characters is the maximum allowed' }
  validates :answer, presence: { message: 'is required' }
end
