class CreateCommitteeMembers < ActiveRecord::Migration
  def change
    create_table :committee_members do |t|
      t.integer :member_id
      t.integer :committee_id

      t.timestamps
    end

    add_index :committee_members, [:member_id, :committee_id], unique: true, name: "cm_uniq"
    add_index :committee_members, :member_id
    add_index :committee_members, :committee_id
  end
end
