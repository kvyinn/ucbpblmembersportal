class AddColumnSemesterToCommitteeMember < ActiveRecord::Migration
  def change
  	add_column :committee_members, :semester_id, :integer
  end
end
