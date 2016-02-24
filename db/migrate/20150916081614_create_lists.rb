class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :user_id
      t.integer :song_id
      t.string :feeling_content
      t.integer :feeling_id
      t.string :list_hashtag
      t.timestamps null: false
    end
  end
end
