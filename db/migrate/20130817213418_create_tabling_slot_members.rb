class CreateTablingSlotMembers < ActiveRecord::Migration
  def change
    create_table :tabling_slot_members do |t|
      t.integer :member_id
      t.integer :tabling_slot_id
      t.integer :status_id

      t.timestamps
    end

    add_index :tabling_slot_members, [:tabling_slot_id, :member_id], unique: true
  end
end
