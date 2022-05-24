class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.belongs_to :board, null: false, foreign_key: true
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
