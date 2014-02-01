class CreateBlogEvents < ActiveRecord::Migration
  def change
    create_table :blog_events do |t|
      t.belongs_to :event
      t.belongs_to :post
      t.timestamps
    end
  end
end
