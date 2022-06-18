# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :board
  validates :question, presence: true,
                       length: { maximum: 200 }
  validates :answer, presence: true
  enum confidence_level: { undefined: 0, very_bad: 1, bad: 2, medium: 3, good: 4, perfect: 5 }, _default: :undefined
end
