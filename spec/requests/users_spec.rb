# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let(:user) { create :user }
  let(:correct_params) { { user: { password: '123456', password_confirmation: '123456' } } }

  context 'when the user is not logged in' do
    describe 'GET /edit' do
      include_examples 'when the user is not logged in', '/user/edit'
    end

    describe 'PATCH /update' do
      before { patch '/user', params: correct_params }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'PUT /remove_avatar' do
      before { put '/remove_avatar', params: correct_params }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end
  end

  context 'when the user is logged in' do
    before { login_as(user, scope: :user) }

    describe 'GET /edit' do
      before { get '/user/edit' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Change my password') }
    end

    describe 'PATCH /update' do
      before do
        patch '/user', params: correct_params
        follow_redirect!
      end

      it { expect(flash[:success]).to include('Password updated') }
    end

    describe 'PUT /remove_avatar' do
      before { put '/remove_avatar', headers: { 'HTTP_REFERER' => 'http://example.com/en/users/edit' } }

      context 'when the user has an avatar' do
        it { expect(user.avatar).not_to be_attached }
      end

      context 'when the user does not have an avatar' do
        before { user.avatar.detach }

        it { is_expected.to redirect_to(request.referer) }
        it { expect(flash[:alert]).to include("You don't have an attached avatar") }
      end
    end
  end
end
