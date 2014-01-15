class CreateCommitteeSemesterMembers < ActiveRecord::Migration
  def change
    create_table :committee_semester_members do |t|

      t.timestamps
    end
  end
end
