class CreateReimbursements < ActiveRecord::Migration
  def change
    create_table :reimbursements do |t|
      t.integer :member_id
      t.float :amount
      t.string :details
      t.boolean :processed

      t.timestamps
    end

    add_index :reimbursements, :member_id
    add_index :reimbursements, :processed
  end
end
