class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  validates :caption, length: { maximum: 100 }
  validates :email, presence: true

  # モデルに、画像アップ用のメソッド（attachment）を追加してフィールド名に（image）を指定。refileを使用するうえでのルール。(idは含めない)
  attachment :image

  # Userモデルに対して、Postモデルが1:Nになるように関連付け
  has_many :posts, dependent: :destroy
  # Userモデルに対して、Likeモデルが1:Nになるように関連付け
  has_many :likes, dependent: :destroy
  # Userモデルに対して、Stockモデルが1:Nになるように関連付け
  has_many :stocks, dependent: :destroy

  # フォロー機能
  # 自分がフォローする側（与フォロー）の関係性
  has_many :relations, class_name: "Relation", foreign_key: "follow_id", dependent: :destroy
  # 与フォロー関係を通じて参照->自分がフォローしている人
  has_many :following, through: :relations, source: :followed
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relations, class_name: "Relation", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relations, source: :follow

  def follow(user_id)
    relations.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relations.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  def self.search_for(content)
    User.where('name LIKE ?', '%' + content + '%')
  end
end
