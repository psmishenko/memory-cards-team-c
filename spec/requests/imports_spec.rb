# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Imports', type: :request do
  let(:user) { create :user }
  let(:user2) { create :user, password: '89712345', email: 'test123@mail.com' }
  let!(:import) { create :import, user_id: user.id }
  let!(:import2) { create :import, user_id: user2.id }
  let(:params) do
    { import: { file: Rack::Test::UploadedFile.new(Rails.root.join('spec/files/download.png'), 'download.png') } }
  end

  context 'when the user is not logged in' do
    describe 'GET /index' do
      include_examples 'when the user is not logged in', '/imports'
    end

    describe 'GET /show' do
      before { get "/imports/#{import.id}" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'GET /new' do
      include_examples 'when the user is not logged in', '/imports/new'
    end

    describe 'GET /edit' do
      before { get "/imports/#{import.id}/edit" }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'POST /create' do
      before { post '/imports', params: params }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'PATCH /update' do
      before { patch "/imports/#{import.id}", params: params }

      it { is_expected.to redirect_to(user_session_path) }
      it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
    end

    describe 'DELETE /destroy' do
      let!(:import1) { create(:import, user_id: user.id) }

      it 'is expected to remain unchanged' do
        expect do
          delete "/imports/#{import1.id}"
        end.to change(Import, :count).by(0)
      end

      it 'is expected to include "You need to sign in or sign up before continuing."' do
        delete "/boards/#{import1.id}"
        expect(flash[:alert]).to include('You need to sign in or sign up before continuing.')
      end
    end
  end

  context 'when the user is logged in' do
    before { sign_in(user, scope: :user) }

    describe 'GET /index' do
      before { get '/imports' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include('Your Uploads') }

      context 'when user has imports' do
        it { expect(assigns(:imports)).to contain_exactly(import) }
      end
    end

    describe 'GET /show' do
      before { get "/imports/#{import.id}" }

      context 'when a user owns a given import' do
        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include('Information about the uploaded file:') }
      end

      context 'when the user does not own the import' do
        before { get "/imports/#{import2.id}" }

        it { is_expected.to redirect_to(imports_path) }
        it { expect(flash[:error]).to include("You don't have access to this file") }
      end
    end

    describe 'GET /new' do
      include_examples 'when the user is logged in', '/imports/new', 'Upload file'
    end

    describe 'GET /edit' do
      before { get "/imports/#{import.id}/edit" }

      context 'when a user owns a given import' do
        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include('Edit uploaded file') }
      end

      context 'when the user does not own the import' do
        before { get "/imports/#{import2.id}/edit" }

        it { is_expected.to redirect_to(imports_path) }
        it { expect(flash[:error]).to include("You don't have access to this file") }
      end
    end

    describe 'POST /create' do
      before do
        post '/imports', params: params
        follow_redirect!
      end

      it { expect(response.body).to include('Your Uploads') }
      it { expect(flash[:success]).to include('File uploaded') }

      context 'when file is empty' do
        before { post '/imports', params: { import: { file: nil } } }

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).to include("File can't be blank") }
      end
    end

    describe 'PATCH /update' do
      before do
        patch "/imports/#{import.id}", params: params
        follow_redirect!
      end

      it { expect(response.body).to include('Your Uploads') }
      it { expect(flash[:success]).to include('File updated') }

      context 'when file is empty' do
        before { patch "/imports/#{import.id}", params: { import: { file: nil } } }

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).to include("File can't be blank") }
      end
    end

    describe 'DELETE /destroy' do
      let!(:import1) { create(:import, user_id: user.id) }

      it 'is expected that the number of imports will decrease by 1' do
        expect do
          delete "/imports/#{import1.id}"
        end.to change(Import, :count).by(-1)
      end

      it 'is expected to include "File deleted"' do
        delete "/imports/#{import1.id}"
        expect(flash[:warn]).to include('File deleted')
      end
    end
  end
end
