class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_board, only: [:show, :edit, :update, :destroy]

  def index
    @boards = Board.all
  end

  def show

  end

  def new
    @board = Board.new
  end

  def create
    board = Board.create(user_id: current_user.id, 
      name: board_params['name'], 
      description: board_params['description'])

    redirect_to board_path(board)
  end

  def edit

  end

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
    params.require(:board).permit(:name, :description)
  end

  def current_board
    @board = Board.find(params[:id])
  end

end
