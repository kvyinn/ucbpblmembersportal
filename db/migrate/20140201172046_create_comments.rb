class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :member_id
      t.belongs_to :post
      t.text :content
      t.timestamps
    end
  end
end
