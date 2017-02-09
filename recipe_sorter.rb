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
				cooktime = recipe_array[2].match(/[\d]+/).to_s.to_i
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
				cooktime = recipe_array[2].match(/[\d]+/).to_s.to_i
				servings = recipe_array[3].strip
				newRecipe = Recipe.new(name,category,cooktime,servings)
				self << newRecipe
			end
		end		
		f = File.open("recipes_space", "r") do |f|
			f.each_line do |line|
				recipe_array = line.match(/^'([\w\s]+)'\s([\w\s]+)\s'([\d]{0,5})[\w\s]+'\s([\d]+)$/i).captures
				name = recipe_array[0].to_s.strip
				category = recipe_array[1].to_s.strip
				cooktime = recipe_array[2].to_s.to_i
				servings = recipe_array[3].to_s.strip
				newRecipe = Recipe.new(name,category,cooktime,servings)
				self << newRecipe
			end
		end
	end

	def rsort(attribute)
		if attribute == "name"
			self.sort! {|x,y| x.name <=> y.name}
		elsif attribute == "category"
			self.sort! {|x,y| [x.category, x.name] <=> [y.category, y.name]}
		elsif attribute == "cooktime"
			self.sort! {|x,y| x.cooktime.to_i <=> y.cooktime.to_i}
		elsif attribute == "servings"
			self.sort! {|x,y| [x.servings, x.cooktime] <=> [y.servings, y.cooktime]}
		else
			return "bad search criteria"
		end
	end

	def addRecipe(recipeString)
		recipe_array = recipeString.split("|")
		name = recipe_array[0].strip
		category = recipe_array[1].strip
		cooktime = recipe_array[2].match(/[\d]+/).to_s.to_i
		servings = recipe_array[3].strip
		self << Recipe.new(name, category, cooktime, servings)
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

######## sinatra stuff ##########
set :port, 8080
set :environment, :production

helpers do
	def tableRow(recipe)
		"<tr><td>#{recipe.name}</td><td>#{recipe.category}</td><td>#{recipe.cooktime}</td><td>#{recipe.servings}</td></tr>"
	end
end

######## controller area ##########

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
	return_message[:recipe] = box.first.send(attribute)
	return_message.to_json
end

post '/recipe' do
	return_message = {}
	jdata = JSON.parse(params[:data], :symbolize_names => true)
	box.addRecipe(jdata[:recipe]) ? return_message[:status] = 'addition success' : return_message[:status] = 'addition failure'
	return_message.to_json
end

get '/recipes' do
	return_message = {}
	box.rsort('category')
	erb :recipes_by_category, :locals => {:box => box}
	return_message[:recipe] = box.first.show
	return_message.to_json
end

get '/recipes/only/:category' do
	subBox = []
	for x in box
		if x.category == params[:category]
			subBox << x
		end
	end
	erb :sorted_recipes, :locals => {:category => params[:category], :box => subBox}	
end

get '/recipes/cooktime' do
	cat = "cooktime"
	box.rsort(cat)
	erb :sorted_recipes, :locals => {:box => box, :category => cat}
end

get '/recipes/category' do
	cat = "category"
	box.rsort('category')
	erb :sorted_recipes, :locals => {:box => box, :category => cat}
end

get '/recipes/name' do
	cat = "name"
	box.rsort('name')
	erb :sorted_recipes, :locals => {:box => box, :category => cat}
end

get '/recipes/servings' do
	cat = "servings"
	box.rsort('servings')
	erb :sorted_recipes, :locals => {:box => box, :category => cat}
end
