class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Userモデルに対して、Postモデルが1:Nになるように関連付け
  has_many :posts, dependent: :destroy
  # Userモデルに対して、Likeモデルが1:Nになるように関連付け
  has_many :likes, dependent: :destroy
  # モデルに、画像アップ用のメソッド（attachment）を追加してフィールド名に（image）を指定。
  # refileを使用するうえでのルール。(idは含めない)
  attachment :image
end
