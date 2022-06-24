# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Errors', type: :request do
  describe 'GET /404' do
    before { get '/404' }

    it { expect(response.status).to eq(404) }
    it { expect(response).to render_template(:not_found) }
  end

  describe 'GET /422' do
    before { get '/422' }

    it { expect(response.status).to eq(422) }
    it { expect(response).to render_template(:unacceptable) }
  end

  describe 'GET /500' do
    before { get '/500' }

    it { expect(response.status).to eq(500) }
    it { expect(response).to render_template(:internal_error) }
  end
end
