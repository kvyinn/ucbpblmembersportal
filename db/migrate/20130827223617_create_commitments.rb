class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.integer :member_id
      t.string :summary
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end

    add_index :commitments, :member_id
  end
end
