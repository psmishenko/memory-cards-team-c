# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_card, except: %i[index new create]

  def index
    @cards = Card.all
  end

  def new
    @card = Card.new
  end

  def create
    card = Card.create!(board_id: 1,
                        question: card_params['question'],
                        answer: card_params['answer'])

    redirect_to cards_path(card)
  end

  def update
    @card.update(card_params)

    redirect_to card_path(@card)
  end

  def destroy
    @card.destroy

    redirect_to cards_path
  end

  private

  def card_params
    params.require(:card)
          .permit(:question, :answer)
  end

  def current_card
    @card = Card.find(params[:id])
  end
end
