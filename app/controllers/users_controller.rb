# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      bypass_sign_in(@user)
      flash[:success] = t('flash.users.update.success')
      redirect_to root_path
    else
      render 'edit'
    end
  end

   def remove_avatar
    @user = current_user
    if @user.avatar.attached?
      @user.avatar.detach
      flash[:success] = t('flash.users.remove_avatar.success')
      redirect_to request.referer
    else
      flash[:error] = t('flash.users.remove_avatar.error')
      redirect_to request.referer
    end 
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation,:avatar)
  end
end
