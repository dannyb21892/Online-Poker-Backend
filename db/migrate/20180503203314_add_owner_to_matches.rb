class AddOwnerToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :owner_id, :integer
  end
end
