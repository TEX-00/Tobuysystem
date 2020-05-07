class ChangeUser < ActiveRecord::Migration[6.0]
  def change
    
    change_table :users do |t|
      t.remove :hashpass
      t.string :password_digest
    end
  end
end
