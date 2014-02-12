class CreateOldPosts < ActiveRecord::Migration
  def change
    create_table :old_posts do |t|

      t.timestamps
    end
  end
end
