###assumptions!
#categories are one word
#no apostrophes in recipes
#servings are not spelled out
#cooktimes are in minutes

#RecipeArray should store recipes as named Hashes

require 'sinatra'
require 'json'

#Recipe Box Class
class RecipeBox < Array
	#require 'rest-client'

	def initialize
		@sorted_by = "not sorted"
	end

	def loadRecipes		
		f = File.open("recipes_comma", "r") do |f|
			f.each_line do |line|
				recipe_array = line.split(",")
				name = recipe_array[0].strip
				category = recipe_array[1].strip
				cooktime = recipe_array[2].strip
				servings = recipe_array[3].strip
				newRecipe = Recipe.new(name,category,cooktime,servings)
				self << newRecipe
			end
		end
		f = File.open("recipes_pipe", "r") do |f|
			f.each_line do |line|
				recipe_array = line.split("|")
				name = recipe_array[0].strip
				category = recipe_array[1].strip
				cooktime = recipe_array[2].strip
				servings = recipe_array[3].strip
				newRecipe = Recipe.new(name,category,cooktime,servings)
				self << newRecipe
			end
		end		
		f = File.open("recipes_space", "r") do |f|
			f.each_line do |line|
				recipe_array = line.match(/^'([\w\s]+)'\s([\w\s]+)\s'([\d]{1,4})[\w\s]+'\s([\d]+)$/i).captures
				name = recipe_array[0].strip
				category = recipe_array[1].strip
				cooktime = recipe_array[2].strip
				servings = recipe_array[3].strip
				newRecipe = Recipe.new(name,category,cooktime,servings)
				self << newRecipe
			end
		end
	end

	def rsort(attribute)
		if attribute == "name"
			self.sort! {|x,y| x.name <=> y.name}
		elsif attribute == "category"
			self.sort! {|x,y| x.category <=> y.category}
		elsif attribute == "cooktime"
			self.sort! {|x,y| x.cooktime <=> y.cooktime}
		elsif attribute == "servings"
			self.sort! {|x,y| x.servings <=> y.servings}
		else
			return "bad search criteria"
		end
	end

	def addRecipe(name,category,cooktime,servings)
		box << Recipe.new(name, category, cooktime, servings)
	end
end #end of Recipe Box class #
	

#Recipe Class	
class Recipe	
	attr_accessor :name, :category, :cooktime, :servings

	def initialize(name, category, cooktime, servings)
		@name = name
		@category = category
		@cooktime = cooktime
		@servings = servings
	end

	def show
		"#{@name} - #{@category} - takes #{@cooktime} - Serves #{@servings}"
	end

end

box = RecipeBox.new

##### sinatra stuff #####
set :port, 8080
set :environment, :production

get '/' do
	"hello dan"
end

post '/empty_box' do
	return_message = {}
	box.clear ? {status: 'empty success'}.to_json : {status: 'empty failed'}.to_json
end

get '/get_recipes' do
	return_message = {}
	if box.loadRecipes
		return_message[:status] = 'recipes loaded'
	else
		return_message[:status]= 'recipes not loaded'
	end
	return_message.to_json
end

post '/sort' do
	return_message = {}
	jdata = JSON.parse(params[:data], symbolize_names: true)
	attribute = jdata[:attribute]
	box.rsort(attribute) ? return_message[:status] = "sort success" : return_message[:status] = "sort failure"
	puts "got one!" + box.first.send(attribute)
	return_message[:recipe] = box.first.send(attribute)
	return_message.to_json
end

post '/recipe' do
	jdata = JSON.parse(params[:data], :symbolize_names => true)
	if jdata.has_key?('name','category','cooktime','servings')
		box.add(jdata[:name],jdata[:category],jdata[:cooktime],jdata[:servings]) ? return_message[:status] = 'success' : return_message[:status] = 'failure'
	end
end

get '/recipes' do
	return_message = {}
	return_message[:recipe] = box.first.show
	return_message.to_json
end

get '/recipes/:category/name' do
end

get '/recipes/cook_time' do
end