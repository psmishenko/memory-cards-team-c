# frozen_string_literal: true

FactoryBot.define do
  factory :board do
    user_id { '1' }
    name { 'board name' }
    description { 'description' }
  end
end
