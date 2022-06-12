# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    board_id { create(:board).id }
    question { 'question' }
    answer { 'answer' }
  end
end
