class AddOldMemberIdToMembers < ActiveRecord::Migration
  def change
    add_column :members, :old_member_id, :integer
  end
end
