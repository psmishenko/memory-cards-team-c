class AddConfidenceLevelToCard < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :confidence_level, :integer
  end
end
