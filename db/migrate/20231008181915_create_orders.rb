class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.timestamp :ordered_at, null: false
      t.float :sum, precision: 10, scale: 2
      t.belongs_to :user

      t.timestamps
    end
  end
end
