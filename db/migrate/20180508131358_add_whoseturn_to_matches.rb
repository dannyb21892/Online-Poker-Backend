class AddWhoseturnToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :whoseturn, :integer
  end
end
