class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.float :total_amount
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
