class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :image_url_normal
      t.string :image_url_small
      t.string :mana_cost
      t.string :cmc
      t.string :type_line
      t.string :oracle_text
      t.string :power
      t.string :toughness

      t.timestamps
    end
  end
end
