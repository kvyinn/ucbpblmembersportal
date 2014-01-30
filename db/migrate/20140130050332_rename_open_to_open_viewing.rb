class RenameOpenToOpenViewing < ActiveRecord::Migration
  def change
  	rename_column :deliberations, :open, :can_view_graph
  end

end
