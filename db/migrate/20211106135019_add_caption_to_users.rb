class AddCaptionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :caption, :text
  end
end
