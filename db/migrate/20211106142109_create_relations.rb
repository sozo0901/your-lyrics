class CreateRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :relations do |t|
      t.string :follow_id
      t.string :followed_id

      t.timestamps
    end
  end
end
