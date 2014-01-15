class CreateSemesterMembers < ActiveRecord::Migration
  def change
    create_table :semester_members do |t|
      t.belongs_to :semester
      t.belongs_to :member
      t.timestamps
    end
  end
end
