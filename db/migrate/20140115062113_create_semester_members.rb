class CreateSemesterMembers < ActiveRecord::Migration
  def change
    create_table :semester_members do |t|

      t.timestamps
    end
  end
end
