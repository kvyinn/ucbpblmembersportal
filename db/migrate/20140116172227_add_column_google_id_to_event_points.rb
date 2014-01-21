class AddColumnGoogleIdToEventPoints < ActiveRecord::Migration
  def change
  	add_column :event_points, :google_id, :string
  end
end
