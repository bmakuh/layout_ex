class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :artist
      t.string :description
      t.datetime :date
      t.decimal :price
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
