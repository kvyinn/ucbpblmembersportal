class AddColumnProfileToMembers < ActiveRecord::Migration
  def change
  	add_column :members, :profile, :string
  end
end
