# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :board
  validates :question, presence: { message: 'Question is required' },
                       length: { maximum: 200, message: '%<count>s characters is the maximum allowed' }
  validates :answer, presence: { message: 'Answer is required' }
end
