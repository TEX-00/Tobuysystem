class CreateToBuys < ActiveRecord::Migration[6.0]
  def change
    create_table :to_buys do |t|
      t.string :name
      t.integer :count
      t.text :special_option
      t.boolean :is_done

      t.references :who_wants, foreign_key: { to_table: :users}
      t.references :who_did, foreign_key: { to_table: :users}, null: true
      t.timestamps
    end
  end
end
