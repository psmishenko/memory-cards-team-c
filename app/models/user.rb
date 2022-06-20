# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]
  has_many :boards, dependent: :destroy

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    user ||= User.create(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20]
    )
    user
  end
end
