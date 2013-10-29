class ChangeEventIdInEventMembers < ActiveRecord::Migration
  def up
    change_column :event_members, :event_id, :string
  end

  def down
    change_column :event_members, :event_id, :string
  end

end
