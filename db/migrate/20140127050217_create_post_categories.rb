class CreatePostCategories < ActiveRecord::Migration
  def change
    create_table :post_categories do |t|
      t.string :name
      t.string :category_type
      t.timestamps
    end
  end
end
