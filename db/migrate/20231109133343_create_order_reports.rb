class CreateOrderReports < ActiveRecord::Migration[7.0]
  def change
    create_table :order_reports do |t|
      t.string :status
      t.string :file
      t.jsonb :payload

      t.timestamps
    end
  end
end
