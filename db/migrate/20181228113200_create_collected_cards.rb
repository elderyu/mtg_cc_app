class CreateCollectedCards < ActiveRecord::Migration[5.2]
  def change
    create_table :collected_cards do |t|
      t.integer :user_id
      t.integer :count
      t.integer :card_id

      t.timestamps
    end
  end
end
