class CreateCollectedCards < ActiveRecord::Migration[5.2]
  def change
    create_table :collected_cards do |t|
      t.integer :user_id
      t.integer :count
      t.string :title

      t.timestamps
    end
  end
end
