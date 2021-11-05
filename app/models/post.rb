class Post < ApplicationRecord
  # belongs_toは、Postモデルからuser_idに関連付けられていて、Userモデルを参照することができる。
  # Postモデルに関連付けられるのは、1つのUserモデル。このため、単数形の「user」になっている。
  belongs_to :user
  # # Postモデルに対して、Likeモデルが1:Nになるように関連付け
  has_many :likes, dependent: :destroy
  # liked_by?メソッドで、引数で渡されたユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べる。
  # 存在していればtrue、存在していなければfalseを返す。
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
  # モデルに、画像アップ用のメソッド（attachment）を追加してフィールド名に（image）を指定。
  # refileを使用するうえでのルール。(idは含めない)
  attachment :image
end
