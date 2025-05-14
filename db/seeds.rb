# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# puts "cleaning DB"
# Recipe.destroy_all

# puts "creating recipe"
# Recipe.create!(
#   name:  "Spaghetti Carbonara",
#   description: "A true Italian Carbonara recipe, it's ready in about 30 minutes. There is no cream....",
#   image_url: "https://ichef.bbci.co.uk/food/ic/food_16x9_1600/recipes/spaghetti_carbonara_16890_16x9.jpg",
#   rating: 4.5,
# )

# Recipe.create!(
#   name:  "Chocolate drip cake",
#   description: "This chocolate drip cake is the ultimate birthday treat for chocolate fans.",
#   image_url: "https://ichef.bbci.co.uk/food/ic/food_16x9_1600/recipes/chocolate_drip_cake_48926_16x9.jpg",
#   rating: 4.8,
# )

# Recipe.create!(
#   name:  "'Nduja pizza",
#   description: "These spicy, tangy homemade pizzas are so much better than anything you can have delivered – the perfect pick-me-up. The gentle salty flavours of crumbly sheeps' cheese are wonderful with spicy 'nduja, but they're not always easy to find in supermarkets, so feel free to swap in shavings of manchego or torn balls of mozzarella.",
#   image_url: "https://www.seriouseats.com/thmb/JH5Jomj2WIdrP_WlzgTSfyZimaw=/750x0/filters:no_upscale():max_bytes(150000):strip_icc()/20211115-OONI-PIZZA-NDUJA-ANDREW-JANJIGIAN-32-cdd758783bc241a3b13046f2b978333d.jpg",
#   rating: 5,
# )

# Recipe.create!(
#   name:  "Chicken and coconut curry",
#   description: "This creamy coconut chicken curry hails from Sri Lanka. The roasted curry powder gives a wonderful toasted aroma to the finished curry.",
#   image_url: "https://ichef.bbci.co.uk/food/ic/food_16x9_1600/recipes/chicken_and_coconut_85358_16x9.jpg",
#   rating: 4.7,
# )

# puts "#{Recipe.count} recipes created"


require "json"
require "open-uri"

categories = ["Breakfast", "Pasta", "Seafood", "Dessert"]

recipe_ids = [] # Store recipe IDs here

categories.each do |category|
  url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category}"
  puts "Fetching recipes for #{category}..."

  response = URI.open(url).read
  data = JSON.parse(response)

  data["meals"].each do |meal|
    puts "Found Recipe ID: #{meal["idMeal"]} - #{meal["strMeal"]}"
    recipe_ids << meal["idMeal"]
  end
end

def recipe_builder(id)
  url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{id}"
  response = URI.open(url).read
  data = JSON.parse(response)
  meal = data["meals"].first

  Recipe.create!(
    name: meal["strMeal"],
    image_url: meal["strMealThumb"],
    description: "Delicious #{meal["strMeal"]} made with love.",
    rating: rand(1.0..5.0).round(1)
  )

  puts "✅ Created Recipe: #{meal["strMeal"]}"
end

puts "Creating recipes..."
recipe_ids.each do |id|
  recipe_builder(id)
end
