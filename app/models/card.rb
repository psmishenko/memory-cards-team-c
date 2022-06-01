# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :board
  validates :question, :answer, presence: true
end
