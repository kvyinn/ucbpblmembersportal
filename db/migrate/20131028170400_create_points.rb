class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :member_id, null: false
      t.integer :value, null: false
      t.string :details

      t.timestamps
    end

    add_index :points, :member_id
  end
end
