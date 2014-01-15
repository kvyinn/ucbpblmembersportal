class CreateEventSemesterMembers < ActiveRecord::Migration
  def change
    create_table :event_semester_members do |t|

      t.timestamps
    end
  end
end
