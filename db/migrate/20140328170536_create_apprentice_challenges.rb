class CreateApprenticeChallenges < ActiveRecord::Migration
  def change
    create_table :apprentice_challenges do |t|
      t.string :name
      t.references :event
      t.integer :first_place
      t.integer :second_place
      t.integer :third_place

      t.timestamps
    end
  end
end
