# frozen_string_literal: true

require 'rails_helper'

describe 'Users::OmniauthCallbacks', type: :request do
  describe '#github' do
    context 'when a git hub user has an email' do
      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                      provider: 'github',
                                                                      uid: '123456789',
                                                                      info: {
                                                                        name: 'Tony Stark',
                                                                        email: 'tony@stark.com'
                                                                      },
                                                                      credentials: {
                                                                        token: 'token',
                                                                        refresh_token: 'refresh token'
                                                                      }
                                                                    })
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
        post '/users/auth/github/callback'
        follow_redirect!
      end

      it { expect(response).to render_template(:home) }
      it { expect(response.body).to include('Successfully authenticated from Github account.') }
    end

    context "when git hub user doesn't have email" do
      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                      provider: 'github',
                                                                      uid: '123456789',
                                                                      info: {
                                                                        name: 'Tony Stark',
                                                                        email: nil
                                                                      },
                                                                      credentials: {
                                                                        token: 'token',
                                                                        refresh_token: 'refresh token'
                                                                      }
                                                                    })
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
        post '/users/auth/github/callback'
        follow_redirect!
      end

      it { expect(response).to render_template(:new) }

      it {
        expect(response.body)
          .to include('Could not authenticate you from Github because &quot;Email can&#39;t be blank&quot;.')
      }
    end

    context 'when invalid credentials' do
      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:github] = :invalid_credentials
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
        post '/users/auth/github/callback'
        follow_redirect!
      end

      it { expect(response).to render_template(:new) }

      it {
        expect(response.body)
          .to include('Could not authenticate you from GitHub because &quot;Invalid credentials&quot;.')
      }
    end
  end
end
