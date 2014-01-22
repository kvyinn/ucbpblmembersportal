class AddDeliberationRefToApplicant < ActiveRecord::Migration
  def change
  	add_column :applicants, :deliberation_id, :integer
    add_index :applicants, :deliberation_id
    add_column :applicant_rankings, :deliberation_id, :integer
    add_index :applicant_rankings, :deliberation_id
  end
end
