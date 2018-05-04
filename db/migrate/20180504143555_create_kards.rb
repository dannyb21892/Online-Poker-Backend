class CreateKards < ActiveRecord::Migration[5.1]
  def change
    create_table :kards do |t|
      t.string :img_link
      t.string :value
      t.string :suit
      t.string :code
      t.integer :player_id
      t.integer :match_id

      t.timestamps
    end
  end
end
