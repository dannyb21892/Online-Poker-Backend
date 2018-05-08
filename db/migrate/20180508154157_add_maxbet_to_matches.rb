class AddMaxbetToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :maxbet, :integer
  end
end
