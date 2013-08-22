class CreateTablingSlots < ActiveRecord::Migration
  def change
    create_table :tabling_slots do |t|
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
