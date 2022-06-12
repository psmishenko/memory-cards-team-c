# frozen_string_literal: true

class Board < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  validates :name, presence: true, length: { minimum: 2 }
  validates :description, presence: true, length: { maximum: 200 }
end
