# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@test.com' }
    password { '123456' }

    trait :with_avatar do
      avatar { fixture_file_upload(Rails.root.join('spec/support/assets/test-image.png'), 'image/png') }
    end
  end
end
