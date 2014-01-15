class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :name

      t.timestamps
    end
  end
end
