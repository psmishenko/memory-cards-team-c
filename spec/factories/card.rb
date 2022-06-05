# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    board_id { '1' }
    question { 'question' }
    answer { 'answer' }
  end
end
