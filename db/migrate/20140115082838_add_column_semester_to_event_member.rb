class AddColumnSemesterToEventMember < ActiveRecord::Migration
  def change
  	add_column :event_members, :semester_id, :integer
  end
end
