class AddPotToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :pot, :integer
  end
end
