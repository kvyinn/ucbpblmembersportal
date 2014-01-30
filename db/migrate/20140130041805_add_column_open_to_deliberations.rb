class AddColumnOpenToDeliberations < ActiveRecord::Migration
  def change
  	add_column :deliberations, :open, :string
  end
end
