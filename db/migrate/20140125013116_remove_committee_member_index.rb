class RemoveCommitteeMemberIndex < ActiveRecord::Migration
  def change
  	remove_index(:committee_members, name: "cm_uniq")
  	add_index :committee_members, [:member_id, :semester_id, :committee_id], unique: true, name: "cm_uniq"
  end
end
