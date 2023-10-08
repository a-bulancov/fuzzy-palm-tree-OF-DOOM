class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.timestamp :ordered_at
      t.float :sum
      t.belongs_to :users

      t.timestamps
    end
  end
end
