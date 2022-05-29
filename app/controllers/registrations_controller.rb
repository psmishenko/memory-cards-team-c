# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update(user_params)
      bypass_sign_in(@user)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params.except('current_password'))
  end
end
