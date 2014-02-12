class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :like_type
      t.belongs_to :member
      t.belongs_to :post
      t.timestamps
    end
  end
end
