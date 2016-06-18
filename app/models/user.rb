class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  # on: :update　以下のメソッドの時だけ実行される
  validates :age , numericality: { only_integer: true , greater_than_or_equal_to: 0}, length: { maximum: 3 }, on: :update
  validates :address , length: { maximum: 10}, on: :update

  has_many :microposts


end
