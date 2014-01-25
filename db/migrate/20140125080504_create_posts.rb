class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
	  t.text :content
      t.string :title
      t.belongs_to :member
      t.integer :edit_tier
      t.integer :view_tier
      t.timestamps
    end
  end
end
