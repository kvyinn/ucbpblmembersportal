class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :remember_token

      t.timestamps
    end

    add_index :members, :name
    add_index :members, [:provider, :uid]
    add_index :members, :remember_token
  end
end
