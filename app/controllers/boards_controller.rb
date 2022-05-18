# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_board, except: %i[index new create]

  def index
    @boards = Board.all
  end

  def show; end

  def new
    @board = Board.new
  end

  def create
    board = Board.create!(user_id: current_user.id,
                          name: board_params['name'],
                          description: board_params['description'])

    redirect_to board_path(board)
  end

  def edit; end

  def update
    @board.update(board_params)

    redirect_to board_path(@board)
  end

  def destroy
    @board.destroy

    redirect_to boards_path
  end

  private

  def board_params
    params.require(:board)
          .permit(:name,
                  :description)
  end

  def find_board
    @board = Board.find(params[:id])
  end
end
