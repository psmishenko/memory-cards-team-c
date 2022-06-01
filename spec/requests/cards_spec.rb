# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards', type: :request do
  describe 'GET /index' do
    context 'when the user is not logged in' do
      it 'returns redirect' do
        get '/cards/index'
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'GET /show' do
    context 'when the user is not logged in' do
      it 'returns redirect' do
        get '/cards/show'
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'GET /new' do
    context 'when the user is not logged in' do
      it 'returns redirect' do
        get '/cards/new'
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'GET /edit' do
    context 'when the user is not logged in' do
      it 'returns redirect' do
        get '/cards/edit'
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
