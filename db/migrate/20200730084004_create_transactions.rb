class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.datetime :date
      t.integer :order_id
      t.integer :customer_id
      t.string :country
      t.string :product_code
      t.string :product_description
      t.integer :quantity
      t.float :unit_price
    end
    add_index :transactions, :customer_id
    add_index :transactions, :country
  end
end
