# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user_names = ["john cena", "razrush1tel", "abc"]
users = []
user_names.each { |name| users << User.create!(name: name) }

order_params = [
  { sum: 205.30,
    ordered_at: "2018-10-08 23:12:24" },
  { sum: 1000.0,
    ordered_at: "2023-10-09 02:12:39" },
  { sum: 80.55,
    ordered_at: "2023-10-09 03:12:39" }]
order_params.each_with_index do |order, index|
  Order.create!(user: users[index], sum: order[:sum], ordered_at: order[:ordered_at])
end
