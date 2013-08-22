class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.string :name
      t.string :abbr

      t.timestamps
    end

    add_index :committees, :abbr
  end
end
