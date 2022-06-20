# frozen_string_literal: true

class ImportsController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :authenticate_user!
  before_action :find_import, except: %i[index new create]

  def index
    @imports = current_user.imports
  end

  def new
    @import = Import.new
  end

  def create
    @import = current_user.imports.build(import_params)
    if @import.save
      flash[:success] = t('flash.imports.create.success')
      redirect_to imports_path
    else
      flash_error
      render 'new'
    end
  end

  def update
    if @import.update(import_params)
      flash[:success] = t('flash.imports.update.success')
      redirect_to imports_path
    else
      flash_error
      render 'edit'
    end
  end

  def destroy
    @import.destroy
    flash[:warn] = t('flash.imports.destroy.success')
    redirect_to imports_path
  end

  private

  def import_params
    params.require(:import)
          .permit(:file)
  end

  def find_import
    @import = current_user.imports.find_by(id: params[:id])
    redirect_to imports_path, flash: { error: t('flash.imports.no_access') } if @import.nil?
  end

  def flash_error
    flash.now[:error] = @import.errors.full_messages[0]
  end
end
