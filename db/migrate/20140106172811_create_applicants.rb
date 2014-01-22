class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.integer :preference1
      t.integer :preference2
      t.integer :preference3
      t.string :image
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
