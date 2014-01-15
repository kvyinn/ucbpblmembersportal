class AddColumnSemesterIdToEventPoints < ActiveRecord::Migration
  def change
  	add_column :event_points, :semester_id, :integer
  end
end
