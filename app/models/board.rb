# frozen_string_literal: true

class Board < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  validates :name, presence: true
  validates :description, presence: true
end
