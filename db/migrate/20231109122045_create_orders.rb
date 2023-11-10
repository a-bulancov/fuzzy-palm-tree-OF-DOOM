class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.date :date
      t.bigint :user_id
      t.bigint :amount

      t.timestamps
    end

    add_index :orders, :user_id
  end
end
