# frozen_string_literal: true

FactoryBot.define do
  factory :board do
    user_id { create(:user).id }
    name { 'board name' }
    description { 'description' }
  end
end
