# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards', type: :request do
  let(:user) { create :user }
  let(:board) { create :board, user_id: user.id }
  let(:card) { create :card, board_id: board.id }
  let(:correct_params) { { card: { question: 'Where is my car dude?', answer: 'Gone in Sixty Seconds' } } }

  context 'when the user is not logged in' do
    describe 'GET /index' do
      include_examples 'when the user is not logged in', '/boards/1/cards'
    end

    describe 'GET /show' do
      before { get "/boards/#{board.id}/cards/#{card.id}" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'GET /new' do
      include_examples 'when the user is not logged in', '/boards/1/cards/new'
    end

    describe 'GET /edit' do
      before { get "/boards/#{board.id}/cards/#{card.id}/edit" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'POST /create' do
      before { post "/boards/#{board.id}/cards/", params: correct_params }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'PATCH /update' do
      before { patch "/boards/#{board.id}/cards/#{card.id}", params: correct_params }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'DELETE /destroy' do
      let!(:card1) { create(:card, board_id: board.id) }

      it 'is expected to remain unchanged' do
        expect do
          delete "/boards/#{board.id}/cards/#{card1.id}"
        end.to change(Card, :count).by(0)
      end

      it 'is expected to include "You need to sign in or sign up before continuing."' do
        delete "/boards/#{board.id}/cards/#{card1.id}"
        expect(flash[:alert]).to include('You need to sign in or sign up before continuing.')
      end
    end
  end

  context 'when the user is logged in' do
    let(:question_blank) { { card: { question: '', answer: 'Gone in Sixty Seconds' } } }
    let(:answer_blank) { { card: { question: 'Where is my car dude?', answer: '' } } }
    let(:long_question) { { card: { question: ('s' * 201).to_s, answer: 'Gone in Sixty Seconds' } } }

    before { login_as(user, scope: :user) }

    describe 'GET /index' do
      before { get "/boards/#{board.id}/cards/" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include(board.name.to_s) }
    end

    describe 'GET /show' do
      before { get "/boards/#{board.id}/cards/#{card.id}" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Back to all cards') }
    end

    describe 'GET /new' do
      before { get "/boards/#{board.id}/cards/new" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('New card') }
    end

    describe 'GET /edit' do
      before { get "/boards/#{board.id}/cards/#{card.id}/edit" }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Edit card') }
    end

    describe 'POST /create' do
      before do
        post "/boards/#{board.id}/cards/", params: correct_params
        follow_redirect!
      end

      it { expect(response.body).to include('Where is my car dude?') }
      it { expect(flash[:success]).to include('Card created') }

      context 'when question empty' do
        before { post "/boards/#{board.id}/cards/", params: question_blank }

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).to include('Question is required') }
      end

      context 'when answer empty' do
        before { post "/boards/#{board.id}/cards/", params: answer_blank }

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).to include('Answer is required') }
      end

      context 'when question so long' do
        before { post "/boards/#{board.id}/cards/", params: long_question }

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).to include('Question 200 characters is the maximum allowed') }
      end
    end

    describe 'PATCH /update' do
      before do
        patch "/boards/#{board.id}/cards/#{card.id}", params: correct_params
        follow_redirect!
      end

      it { expect(response.body).to include('Where is my car dude?') }
      it { expect(response.body).to include('Gone in Sixty Seconds') }
      it { expect(flash[:success]).to include('Card updated') }

      context 'when question empty' do
        before { patch "/boards/#{board.id}/cards/#{card.id}", params: question_blank }

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).to include('Question is required') }
      end

      context 'when answer empty' do
        before { patch "/boards/#{board.id}/cards/#{card.id}", params: answer_blank }

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).to include('Answer is required') }
      end

      context 'when question so long' do
        before { patch "/boards/#{board.id}/cards/#{card.id}", params: long_question }

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).to include('Question 200 characters is the maximum allowed') }
      end
    end

    describe 'DELETE /destroy' do
      let!(:card1) { create(:card, board_id: board.id) }

      it 'is expected that the number of cards will decrease by 1' do
        expect do
          delete "/boards/#{board.id}/cards/#{card1.id}"
        end.to change(Card, :count).by(-1)
      end

      it 'is expected to include "Card deleted"' do
        delete "/boards/#{board.id}/cards/#{card1.id}"
        expect(flash[:warn]).to include('Card deleted')
      end
    end
  end
end
