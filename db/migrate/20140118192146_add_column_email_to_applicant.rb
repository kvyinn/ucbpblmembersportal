class AddColumnEmailToApplicant < ActiveRecord::Migration
  def change
  	add_column :applicants, :email, :string
  end
end
