# frozen_string_literal: true

ActiveAdmin.register Card do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :board_id, :question, :answer
  #
  # or
  #
  # permit_params do
  #   permitted = [:board_id, :question, :answer]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
