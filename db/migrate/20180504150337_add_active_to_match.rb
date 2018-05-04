class AddActiveToMatch < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :active, :boolean
  end
end
