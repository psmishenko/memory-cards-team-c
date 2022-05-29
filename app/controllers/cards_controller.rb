# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_board
  before_action :find_card, except: %i[index new create]

  def index
    @cards = @board.cards.order(created_at: :desc)
  end

  def new
    @card = @board.cards.build
  end

  def create
    @card = @board.cards.build(card_params)
    if @card.save
      flash[:success] = 'Card created'
      respond_to { |format| format.html { redirect_to board_cards_path(@board) } }
    else
      flash_error
      respond_to { |format| format.html { render :new, status: :unprocessable_entity } }
    end
  end

  def update
    @card.update(card_params)
    if @card.update(card_params)
      flash[:success] = 'Card updated'
      respond_to { |format| format.html { redirect_to board_card_path(@board) } }
    else
      flash_error
      respond_to { |format| format.html { render :edit, status: :unprocessable_entity } }
  end

  def destroy
    @card.destroy
    flash[:warn] = 'Card deleted'
    redirect_to board_cards_path
  end

  private

  def card_params
    params.require(:card)
          .permit(:board_id, :question, :answer)
  end

  def find_card
    @card = @board.cards.find(params[:id])
  end

  def find_board
    @board = Board.find(params[:board_id])
  end

  def flash_error
    flash.now[:error] = @card.errors.full_messages[0]
  end
end
