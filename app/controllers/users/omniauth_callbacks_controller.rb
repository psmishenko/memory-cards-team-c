# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      handle_auth 'Github'
    end

    def google_oauth2
      handle_auth 'Google'
    end

    # rubocop:disable Metrics/AbcSize

    def handle_auth(kind)
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: kind
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.github_data'] = request.env['omniauth.auth'].except(:extra)
        flash[:alert] =
          I18n.t 'devise.omniauth_callbacks.failure', kind: kind, reason: @user.errors.full_messages.join("\n")
        redirect_to new_user_registration_url
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
