class CreateDeliberations < ActiveRecord::Migration
  def change
    create_table :deliberations do |t|
      t.string :name
      t.timestamps
    end
  end
end
