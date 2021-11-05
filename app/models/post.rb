class Post < ApplicationRecord
  # Postモデルに対して、Userモデルとの関係性を追加。
  # belongs_toは、Postモデルからuser_idに関連付けられていて、Userモデルを参照することができる。
  # Postモデルに関連付けられるのは、1つのUserモデル。このため、単数形の「user」になっている。
  belongs_to :user
  # モデルに、画像アップ用のメソッド（attachment）を追加してフィールド名に（image）を指定。
  # refileを使用するうえでのルール。(idは含めない)
  attachment :image
end
