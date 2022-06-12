# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  protect_from_forgery except: :update

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
