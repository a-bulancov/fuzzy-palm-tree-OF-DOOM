class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :filename, null: false
      t.boolean :ready, default: false

      t.timestamps
    end
  end
end
