class AddColumnGoogleIdToEventMembers < ActiveRecord::Migration
  def change
  	add_column :event_members, :google_id, :string
  end
end
