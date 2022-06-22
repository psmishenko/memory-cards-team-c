# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[github google_oauth2]
  has_many :boards, dependent: :destroy
  has_many :imports, dependent: :destroy
  has_one_attached :avatar
  validates :avatar, file_size: { less_than_or_equal_to: 2.megabytes },
                     content_type: ['image/jpeg', 'image/png', 'image/gif']

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    user ||= User.create(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      email: auth.info.email,
      image: auth.info.image,
      password: Devise.friendly_token[0, 20]
    )
    user
  end
end
