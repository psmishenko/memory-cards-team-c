# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Boards', type: :request do
  let(:user) { create :user }
  let(:board) { create :board, user_id: user.id }

  context 'when the user is not logged in' do
    describe 'GET /index' do
      include_examples 'when the user is not logged in', '/boards'
    end

    describe 'GET /show' do
      before { get "/boards/#{board.id}" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'GET /new' do
      include_examples 'when the user is not logged in', '/boards/new'
    end

    describe 'GET /edit' do
      before { get "/boards/#{board.id}/edit" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'POST /create' do
      before { post '/boards', params: { board: { name: 'My Board', description: 'Test' } } }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'PATCH /update' do
      before { patch board_url(board), params: { board: { name: 'My Board', description: 'Test' } } }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'DELETE /destroy' do
      let!(:board1) { create(:board, user_id: user.id) }

      it 'is expected to remain unchanged' do
        expect do
          delete "/boards/#{board1.id}"
        end.to change(Card, :count).by(0)
      end

      it 'is expected to include "You need to sign in or sign up before continuing."' do
        delete "/boards/#{board1.id}"
        expect(flash[:alert]).to include('You need to sign in or sign up before continuing.')
      end
    end
  end

  context 'when the user is logged in' do
    before { sign_in(user, scope: :user) }

    describe 'GET /index' do
      include_examples 'when the user is logged in', '/boards', 'Boards'
    end

    describe 'GET /show' do
      before { get "/boards/#{board.id}" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Board information') }
    end

    describe 'GET /new' do
      include_examples 'when the user is logged in', '/boards/new', 'Create Board'
    end

    describe 'GET /edit' do
      before { get "/boards/#{board.id}/edit" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Edit board') }
    end

    describe 'POST /create' do
      before do
        post '/boards', params: { board: { name: 'My Board', description: 'Test' } }
        follow_redirect!
      end

      it { expect(response.body).to include('My Board') }
      it { expect(flash[:success]).to include('Board created') }

      context 'when name is empty' do
        before { post '/boards', params: { board: { name: '', description: 'Test' } } }

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).to include("Name can't be blank") }
      end

      context 'when description is empty' do
        before { post '/boards', params: { board: { name: 'My Board', description: '' } } }

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).to include("Description can't be blank") }
      end
    end

    describe 'PATCH /update' do
      before do
        patch board_url(board), params: { board: { name: 'My Board', description: 'Test' } }
        follow_redirect!
      end

      it { expect(response.body).to include('My Board') }
      it { expect(response.body).to include('Test') }
      it { expect(flash[:success]).to include('Board updated') }

      context 'when name is empty' do
        before { patch board_url(board), params: { board: { name: '', description: 'Test' } } }

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).to include("Name can't be blank") }
      end

      context 'when description is empty' do
        before { patch board_url(board), params: { board: { name: 'My Board', description: '' } } }

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).to include("Description can't be blank") }
      end
    end

    describe 'DELETE /destroy' do
      let!(:board1) { create(:board, user_id: user.id) }

      it 'is expected that the number of boards will decrease by 1' do
        expect do
          delete board_url(board1)
        end.to change(Board, :count).by(-1)
      end

      it 'is expected to include "Board deleted"' do
        delete board_url(board1)
        expect(flash[:warn]).to include('Board deleted')
      end
    end
  end
end
