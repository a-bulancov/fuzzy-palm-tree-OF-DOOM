class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.string :value, null: false
      t.timestamp :expires, null: false

      t.timestamps null: false
    end
  end
end
