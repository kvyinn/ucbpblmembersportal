class CreateDeliberationAssignments < ActiveRecord::Migration
  def change
    create_table :deliberation_assignments do |t|
      t.integer :deliberation_id
      t.integer :applicant
      t.integer :committee

      t.timestamps
    end
  end
end
