class AddColumnSemesterToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :semester_id, :integer
  end
end
