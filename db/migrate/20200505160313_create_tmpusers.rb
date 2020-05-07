class CreateTmpusers < ActiveRecord::Migration[6.0]
  def change
    create_table :tmpusers do |t|
      t.string :email ,null:false
      t.string :uuid ,null:false
      t.datetime :expire_at, null:false
      t.timestamps
    end
  end
end
