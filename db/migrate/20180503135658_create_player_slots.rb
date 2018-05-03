class CreatePlayerSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :player_slots do |t|
      t.integer :player_id
      t.integer :match_id

      t.timestamps
    end
  end
end
