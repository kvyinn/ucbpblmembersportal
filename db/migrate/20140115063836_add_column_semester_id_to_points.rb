class AddColumnSemesterIdToPoints < ActiveRecord::Migration
  def change
  	add_column :points, :semester_id, :integer
  end
end
