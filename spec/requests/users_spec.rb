# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let!(:user) { create :user, :with_avatar }
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
      end

      context 'when a user parameters is valid' do
        it { expect(flash[:success]).to include('Password updated') }
        it { is_expected.to redirect_to(root_path) }
      end

      context 'when a user parameters is invalid' do
        let(:correct_params) { { user: { password: '', password_confirmation: '' } } }

        it { expect(response).to render_template(:edit) }
      end
    end

    describe 'PUT /remove_avatar' do
      context 'when the user has an avatar' do
        before { put '/remove_avatar', headers: { 'HTTP_REFERER' => 'http://example.com/en/users/edit' } }

        it { expect(user.avatar).not_to be_attached }
        it { is_expected.to redirect_to(request.referer) }
        it { expect(flash[:success]).to include('Avatar removed. Set to Github/Google or default image') }
      end

      context 'when the user does not have an avatar' do
        before do
          user.avatar.detach
          user.reload
          put '/remove_avatar', headers: { 'HTTP_REFERER' => 'http://example.com/en/users/edit' }
        end

        it { expect(flash[:alert]).to include("You don't have an attached avatar") }
        it { is_expected.to redirect_to(request.referer) }
      end
    end
  end
end
