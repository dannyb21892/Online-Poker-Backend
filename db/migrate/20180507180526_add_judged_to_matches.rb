class AddJudgedToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :judged, :boolean
  end
end
