# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :board
  validates :question, presence: true,
                       length: { maximum: 200 }
  validates :answer, presence: true
end
