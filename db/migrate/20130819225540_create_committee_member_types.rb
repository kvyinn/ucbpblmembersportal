class CreateCommitteeMemberTypes < ActiveRecord::Migration
  def change
    create_table :committee_member_types do |t|
      t.string :name
      t.integer :tier

      t.timestamps
    end

    add_column :committee_members, :committee_member_type_id, :integer
    add_index :committee_members, :committee_member_type_id, name: "cm_type_id"

    add_index :committee_member_types, :tier
  end
end
