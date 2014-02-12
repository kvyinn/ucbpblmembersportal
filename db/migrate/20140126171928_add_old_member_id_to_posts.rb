class AddOldMemberIdToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :old_post_id, :integer
  end
end
