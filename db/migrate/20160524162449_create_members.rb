class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :team_name
      t.integer :espn_id

      t.timestamps null: false
    end
  end
end
