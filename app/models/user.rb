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

  ########################################################################################################################
  # following_relationshipsのforeign_keyのfollower_idにuserのidが入るので、user.following_relationshipsによって、
  # userがフォローしている場合のrelationshipの集まりを取得
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  # throughには、following_relationshipsが指定されていて、following_relationshipsを経由してフォローしているユーザーの集まりを取得
  # userがフォローしている人は、following_relationshipsのfollowed_idに一致するユーザーになるので、sourceとしてfollowedを指定
  has_many :following, through: :following_relationships, source: :followed
  
  # --------------------------------------------------------------------------------------------------------------------#
  # follower_relationshipsのforeign_keyのfollowed_idにuserのidが入るので、
  # user.follower_relationshipsによって、userがフォローされている場合のrelationshipの集まりを取得
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  # throughには、follower_relationshipsが指定されていて、follower_relationshipsを経由してuserがフォローされているユーザーの集まりを取得
  # userをフォローしている人は、follower_relationshipsのfollower_idに一致するユーザーになるので、sourceとしてfollowerを指定
  has_many :follower, through: :follower_relationships, source: :follower
  # --------------------------------------------------------------------------------------------------------------------#

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following.include?(other_user)
  end
  ########################################################################################################################


end
