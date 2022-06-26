# frozen_string_literal: true

class CardImport
  def initialize(params)
    @user = params[:user]
    @import = params[:import]
  end

  def call
    file = find_file
    data = CSV.parse(file, headers: false)
    data.each do |array|
      unless array[0] == 'board_name'
        create_board(array) if Board.find_by(name: array[0]).blank?
        create_card(array)
      end
    end
  end

  private

  # rubocop:disable Metrics/AbcSize
  def find_file
    s3 = Aws::S3::Resource.new(region: 'eu-central-1',
                               access_key_id: Rails.application.credentials.dig(
                                 :aws, :access_key_id
                               ),
                               secret_access_key: Rails.application.credentials.dig(
                                 :aws, :secret_access_key
                               ))
    bucket = s3.bucket(Rails.application.credentials.dig(:aws, :bucket))
    bucket.object(@import.file.blob.key.to_s).get.body.string
  end
  # rubocop:enable Metrics/AbcSize

  def create_board(array)
    @user.boards.build({ name: array[0], description: 'Import' }).save!
  end

  def create_card(array)
    board = Board.find_by(name: array[0])
    board.cards.build({ question: array[1], answer: array[2] }).save!
  end
end
