#assumptions
#categories are one word
#no apostrophes in recipes
#servings are not spelled out

#RecipeArray should store recipes as named Hashes

require 'sinatra'
require 'json'

module sortAble

end

class RecipeBox

	def fileGetter

		#this method should take the recipe files and put them into an array which can be accessed by other methods?
	end

	def saveRecipe(line)
		new_record = Hash.new
		new_record[name] = line.shift
		new_record[category] = line.shift
		new_record[cook_time] = line.shift
		new_record[servings] = line.shift
		return new_record
	end

end

class Recipe	
	def initialize(name, category, cooktime, servings)
		@name = name
		@category = category
		@cooktime = cooktime
		@servings = servings
	end

	def <=>(attribute)
		if attribute == "cooktime"
			compare = self.select(/[\d]{1,4}/)
		end
	end
end

##### API stuff #####
set :port, 8080
set :environment, :production

get '/read_in' do
	fileGetter
end

get '/sort' do
	#view that offers options of 
end

post '/sort/name' do
end

post '/sort/category' do
end

post '/sort/cooktime' do
end

post '/sort/servings' do
end
