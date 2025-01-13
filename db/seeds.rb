# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Cleaning database..."

OrderItem.destroy_all  # Supprimer tous les order_items en premier
Order.destroy_all      # Supprimer toutes les commandes
Item.destroy_all       # Supprimer tous les produits
User.destroy_all       # Supprimer tous les utilisateurs

puts "Database cleaned!"


puts "Seeding users..."

user1 = User.create!(
  email: "dorian@hotmail.fr",
  password: "coucou",
  password_confirmation: "coucou"
)

user2 = User.create!(
  email: "dorian@gmail.com",
  password: "coucou",
  password_confirmation: "coucou"
)

puts "Users created successfully!"



# Création des produits
puts "Seeding items..."
item1 = Item.create!(name: "Produit A", description: "Description A", price: 25.0)
item2 = Item.create!(name: "Produit B", description: "Description B", price: 15.0)
item3 = Item.create!(name: "Produit C", description: "Description C", price: 10.0)
item4 = Item.create!(name: "Produit D", description: "Description D", price: 30.0)

puts "Items created!"

# Création d'une commande avec des produits
puts "Seeding orders..."
order = Order.create!(user: user1, status: "pending", total_amount: 0)

# Ajouter les produits à la commande
OrderItem.create!(order: order, item: item1, item_quantity: 2, price_at_order: item1.price)
OrderItem.create!(order: order, item: item2, item_quantity: 1, price_at_order: item2.price)

# Mise à jour du total de la commande
order.update!(total_amount: order.order_items.sum { |oi| oi.item_quantity * oi.price_at_order })

puts "Orders created!"
