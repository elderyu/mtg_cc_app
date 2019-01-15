class CreateCollectedCards < ActiveRecord::Migration[5.2]
  def change
    create_table :collected_cards do |t|
      t.integer :user_id
      t.integer :count
      t.string :card_id
      t.string :face_id
      t.timestamps
    end
  end
end
