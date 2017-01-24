#assumptions
#categories are one word
#no apostrophes in recipes
#servings are not spelled out

#RecipeArray should store recipes as named Hashes

require 'sinatra'

class RecipeBox < Array

	def sortRecipes(attribute, recipeArray)
		if self.empty?
			puts "Box is empty dumbass."
		else
			if attribute == "name"
				response = RestClient.get 'http://localhost:8080/sort_name'
			elsif attribute == "category"
				response = RestClient.get 'http://localhost:8080/sort_category'
			elsif attribute == "cook_time"
				response = RestClient.get 'http://localhost:8080/sort_cooktime'
			elsif attribute == "servings"
				response = RestClient.get 'http://localhost:8080/sort_servings'
			end	
		end
	end

	def <=>(attribute)
	end

	def getRecipes
		response = RestClient.get 'http://localhost:8080/get_recipes'
	end



end

class Recipe	
	def initialize(name, category, cooktime, servings)
		@name = name
		@category = category
		@cooktime = cooktime
		@servings = servings
	end

end

##### API stuff #####
set :port, 8080
set :environment, :production

get '/get_recipes' do
	
end

post '/sort/name' do
	i = 0
	while i < (recipeArray.length - 1) do
		recipeArray[i].<=>(attribute, recipeArray[i+1])
	end
end

post '/sort/category' do
end

post '/sort/cooktime' do
end

post '/sort/servings' do
end
