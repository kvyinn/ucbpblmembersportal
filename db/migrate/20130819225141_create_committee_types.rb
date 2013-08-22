class CreateCommitteeTypes < ActiveRecord::Migration
  def change
    create_table :committee_types do |t|
      t.string :name
      t.integer :tier

      t.timestamps
    end

    add_column :committees, :committee_type_id, :integer
    add_index :committees, :committee_type_id

    add_index :committee_types, :tier
  end
end
