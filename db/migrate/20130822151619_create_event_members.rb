class CreateEventMembers < ActiveRecord::Migration
  def change
    create_table :event_members do |t|
      t.integer :event_id
      t.integer :member_id

      t.timestamps
    end

    add_index :event_members, :event_id
    add_index :event_members, :member_id
    add_index :event_members, [:event_id, :member_id], unique: true
  end
end
