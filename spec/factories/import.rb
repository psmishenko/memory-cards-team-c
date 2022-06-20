# frozen_string_literal: true

FactoryBot.define do
  factory :import do
    user_id { create(:user).id }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/files/download.png'), 'download.png') }
  end
end
