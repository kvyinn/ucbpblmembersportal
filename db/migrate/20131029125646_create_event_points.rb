class CreateEventPoints < ActiveRecord::Migration
  def change
    create_table :event_points do |t|
      t.string :event_id, null: false
      t.integer :value, null: false, default: 0

      t.timestamps
    end

    add_index :event_points, :event_id, unique: :true
  end
end
