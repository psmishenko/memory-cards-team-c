# frozen_string_literal: true

RSpec.shared_examples 'when the user is not logged in' do |url|
  before { get url }

  it { is_expected.to redirect_to(user_session_path) }
  it { expect(flash[:alert]).to include('You need to sign in or sign up before continuing.') }
end

RSpec.shared_examples 'when the user is logged in' do |url, exceptions|
  let(:user) { create :user }
  let(:board) { create :board, user_id: user.id }
  before do
    login_as(user, scope: :user)
    get url
  end

  it { expect(response).to have_http_status(:ok) }
  it { expect(response.body).to include(exceptions) }
end
