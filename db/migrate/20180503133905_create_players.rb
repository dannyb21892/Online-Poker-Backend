class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :username
      t.integer :money

      t.timestamps
    end
  end
end
