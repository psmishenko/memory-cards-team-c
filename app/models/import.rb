# frozen_string_literal: true

class Import < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  validates :file, attached: true, size: { less_than: 10.megabytes }
end
