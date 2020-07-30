require 'csv'
CSV.foreach(Rails.root.join('lib/memory-tech-challenge-data.csv'), headers: true) do |row|
  
  Transaction.create({
    date: row[0],
    order_id: row[1],
    customer_id: row[2],
    country: row[3],
    product_code: row[4],
    product_description: row[5],
    quantity: row[6],
    unit_price: row[7],
  })
end