class AddColumnViewPermissionToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :view_permissions, :text
  end
end
