class CreateApplicantRankings < ActiveRecord::Migration
  def change
    create_table :applicant_rankings do |t|
      t.integer :applicant
      t.integer :value
      t.text :notes
      t.integer :committee

      t.timestamps
    end
  end
end
