# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let(:user) { create :user }
  let(:correct_params) { { user: { name: 'test_name', email: 'test@test.com' } } }

  context 'when the user is not logged in' do
    describe 'GET /edit' do
      include_examples 'when the user is not logged in', '/users/edit'
    end

    describe 'PATCH /update' do
      before { patch '/users/', params: correct_params }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end
  end

  context 'when the user is logged in' do
    before { login_as(user, scope: :user) }

    describe 'GET /edit' do
      before { get '/users/edit' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Edit User') }
    end

    describe 'PATCH /update' do
      before do
        patch '/users', params: correct_params
        follow_redirect!
      end

      it { expect(response.body).to include('test_name') }
      it { expect(response.body).to include('Your account has been updated successfully.') }
    end
  end
end
