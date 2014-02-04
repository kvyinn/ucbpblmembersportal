class AddColumnDeliberationSettingsToDeliberations < ActiveRecord::Migration
  def change
  	add_column :deliberations, :deliberation_settings, :text
  end
end
