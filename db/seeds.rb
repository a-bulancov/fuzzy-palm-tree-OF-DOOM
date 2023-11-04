# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create!(username: "admin", email: "admin@localhost.local")

user.orders.create!(order_date: 1.day.ago, price: 10.10)
user.orders.create!(order_date: 2.day.ago, price: 20.20)
user.orders.create!(order_date: Date.today, price: 30.20)
