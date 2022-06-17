# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_board
  before_action :find_card, except: %i[index new create learning]

  def index
    @cards = @board.cards.order(created_at: :desc)
  end

  def new
    @card = @board.cards.build
  end

  def create
    @card = @board.cards.build(card_params)
    if @card.save
      flash[:success] = t('flash.cards.create.success')
      redirect_to board_cards_path
    else
      flash_error
      render 'new'
    end
  end

  def update
    if @card.update(card_params)
      flash[:success] = t('flash.cards.update.success')
      redirect_to board_cards_path
    else
      flash_error
      render 'edit'
    end
  end

  def destroy
    @card.destroy
    flash[:warn] = t('flash.cards.destroy.success')
    redirect_to board_cards_path
  end

  def learning
    @cards = @board.cards
    if @cards.empty?
      redirect_to board_cards_path(@board), notice: t('flash.cards.learning.add_cards')
    else
      render 'learning'
    end
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
    @board = current_user.boards.find_by(id: params[:board_id])
    redirect_to boards_path, flash: { error: t('flash.cards.no_access') } if @board.nil?
  end

  def flash_error
    flash.now[:error] = @card.errors.full_messages[0]
  end
end
