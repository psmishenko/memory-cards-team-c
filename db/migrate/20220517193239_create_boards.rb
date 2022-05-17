class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
