# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Cleaning database..."
Item.destroy_all

puts "Creating 10 items..."

10.times do |i|
  item = Item.create!(
    name: "Item ##{i + 1}",
    description: "Description for Item ##{i + 1}",
    price: rand(10.0..500.0).round(2) # Prix aléatoire entre 10€ et 500€
  )
  puts "Created: #{item.name} - #{item.price}€"
end

puts "✅ Seeding completed!"
