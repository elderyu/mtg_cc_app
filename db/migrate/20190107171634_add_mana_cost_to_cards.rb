class AddManaCostToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :mana_cost, :string, array: true
  end
end
