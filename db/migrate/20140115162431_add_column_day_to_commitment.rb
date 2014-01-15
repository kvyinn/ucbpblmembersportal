class AddColumnDayToCommitment < ActiveRecord::Migration
  def change
  	add_column :commitments, :day, :integer
  	add_column :commitments, :start_hour, :integer
  	add_column :commitments, :end_hour, :integer
  end
end
