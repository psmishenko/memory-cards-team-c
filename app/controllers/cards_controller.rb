# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_board
  before_action :current_card, except: %i[index new create]

  def index
    @cards = @board.cards
  end

  def new
    @card = @board.cards.build
  end

  def create
    @card = @board.cards.build(card_params)
    respond_to do |format|
      if @card.save
        format.html { redirect_to board_cards_path(@board) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @card.update(card_params)
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to board_card_path(@board) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy

    redirect_to board_cards_path
  end

  private

  def card_params
    params.require(:card)
          .permit(:board_id, :question, :answer)
  end

  def current_card
    @card = @board.cards.find(params[:id])
  end

  def current_board
    @board = Board.find(params[:board_id])
  end
end
