# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Boards', type: :request do
  let(:user) { create :user }
  let(:board) { create :board, user_id: user.id }

  describe 'GET /index' do
    context 'when the user is not logged in' do
      include_examples 'when the user is not logged in', '/boards'
    end

    context 'when the user is logged in' do
      include_examples 'when the user is logged in', '/boards', 'Boards'
    end
  end

  describe 'GET /show' do
    context 'when the user is not logged in' do
      before { get "/boards/#{board.id}" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    context 'when the user is logged in' do
      before do
        sign_in(user, scope: :user)
        get "/boards/#{board.id}"
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Board information') }
    end
  end

  describe 'GET /new' do
    context 'when the user is not logged in' do
      include_examples 'when the user is not logged in', '/boards/new'
    end

    context 'when the user is logged in' do
      include_examples 'when the user is logged in', '/boards/new', 'Create Board'
    end
  end

  describe 'GET /edit' do
    context 'when the user is not logged in' do
      before { get "/boards/#{board.id}/edit" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    context 'when user logged in' do
      before do
        sign_in(user, scope: :user)
        get "/boards/#{board.id}/edit"
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Edit board') }
    end
  end

  describe 'POST /create' do
    context 'when the user is not logged in' do
      before { post '/boards', params: { board: { name: 'My Board', description: 'Test' } } }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    context 'when the user is logged in and data correct' do
      before do
        sign_in(user, scope: :user)
        post '/boards', params: { board: { name: 'My Board', description: 'Test' } }
        follow_redirect!
      end

      it { expect(response.body).to include('My Board') }
      it { expect(flash[:success]).to include('Board created') }
    end

    context 'when the user is logged in and name empty' do
      before do
        sign_in(user, scope: :user)
        post '/boards', params: { board: { name: '', description: 'Test' } }
      end

      it { expect(response).to render_template(:new) }
      it { expect(flash[:error]).to include("Name can't be blank") }
    end

    context 'when the user is logged in and description empty' do
      before do
        sign_in(user, scope: :user)
        post '/boards', params: { board: { name: 'My Board', description: '' } }
      end

      it { expect(response).to render_template(:new) }
      it { expect(flash[:error]).to include("Description can't be blank") }
    end
  end

  describe 'PATCH /update' do
    context 'when the user is not logged in' do
      before { patch board_url(board), params: { board: { name: 'My Board', description: 'Test' } } }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    context 'when the user is logged in and data correct' do
      before do
        sign_in(user, scope: :user)
        patch board_url(board), params: { board: { name: 'My Board', description: 'Test' } }
        follow_redirect!
      end

      it { expect(response.body).to include('My Board') }
      it { expect(response.body).to include('Test') }
      it { expect(flash[:success]).to include('Board updated') }
    end

    context 'when the user is logged in and name empty' do
      before do
        sign_in(user, scope: :user)
        patch board_url(board), params: { board: { name: '', description: 'Test' } }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(flash[:error]).to include("Name can't be blank") }
    end

    context 'when the user is logged in and description empty' do
      before do
        sign_in(user, scope: :user)
        patch board_url(board), params: { board: { name: 'My Board', description: '' } }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(flash[:error]).to include("Description can't be blank") }
    end
  end

  describe 'DELETE /destroy' do
    let!(:board1) { create(:board, user_id: user.id) }

    context 'when the user is not logged in' do
      it 'is expected to destroy the requested card' do
        expect do
          delete "/boards/#{board1.id}"
        end.to change(Card, :count).by(0)
      end

      it 'is expected to include "Card deleted"' do
        delete "/boards/#{board1.id}"
        expect(flash[:alert]).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when the user is logged in' do
      let!(:board1) { create(:board, user_id: user.id) }

      before { sign_in(user, scope: :user) }

      it 'destroys the requested board' do
        expect do
          delete board_url(board1)
        end.to change(Board, :count).by(-1)
      end

      it 'expect flash' do
        delete board_url(board1)
        expect(flash[:warn]).to include('Board deleted')
      end
    end
  end
end
