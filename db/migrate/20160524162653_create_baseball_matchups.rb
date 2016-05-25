class CreateBaseballMatchups < ActiveRecord::Migration
  def change
    create_table :baseball_matchups do |t|
      t.integer :espn_id
      t.integer :week
      t.integer :runs
      t.integer :hr
      t.integer :rbi
      t.integer :sb
      t.float :obp
      t.float :slg
      t.float :ip
      t.integer :qs
      t.integer :sv
      t.float :era
      t.float :whip
      t.float :k9

      t.timestamps null: false
    end
  end
end
