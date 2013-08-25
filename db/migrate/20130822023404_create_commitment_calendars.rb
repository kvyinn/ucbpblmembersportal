class CreateCommitmentCalendars < ActiveRecord::Migration
  def change
    create_table :commitment_calendars do |t|
      t.integer :member_id
      t.string :calendar_id
      t.string :acl_id

      t.timestamps
    end

    add_index :commitment_calendars, :member_id
    add_index :commitment_calendars, :calendar_id
    add_index :commitment_calendars, [:member_id, :calendar_id], unique: true
  end
end
