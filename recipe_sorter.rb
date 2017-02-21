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
			self.sort! {|x,y| [x.servings] <=> [y.servings]}
		else
			return "bad search criteria"
		end
	end

	def doubleSort(attribute1, attribute2)
		self.sort! {|x,y| [x.send(attribute1), x.send(attribute2)] <=> [y.send(attribute1), y.send(attribute2)]}		
	end

	def doubleSortDecending(attribute1, attribute2)
		if attribute1 == ("cooktime" or "servings")
			self.sort! {|x,y| [y.send(attribute1).to_i, y.send(attribute2).to_i] <=> [x.send(attribute1).to_i, x.send(attribute2).to_i]}
		else
			self.sort! {|x,y| [y.send(attribute1), y.send(attribute2)] <=> [x.send(attribute1), x.send(attribute2)]}			
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


post '/api/empty_box' do
	return_message = {}
	box.clear ? {status: 'empty success'}.to_json : {status: 'empty failed'}.to_json
end

get '/api/get_recipes' do
	return_message = {}
	if box.loadRecipes
		return_message[:status] = 'recipes loaded'
	else
		return_message[:status]= 'recipes not loaded'
	end
	return_message.to_json
end

post '/api/sort' do
	return_message = {}
	jdata = JSON.parse(params[:data], symbolize_names: true)
	attribute = jdata[:attribute]
	box.rsort(attribute) ? return_message[:status] = "sort success" : return_message[:status] = "sort failure"
	return_message[:recipe] = box.first.send(attribute)
	return_message.to_json
end

post '/api/recipe' do
	return_message = {}
	jdata = JSON.parse(params[:data], :symbolize_names => true)
	box.addRecipe(jdata[:recipe]) ? return_message[:status] = 'addition success' : return_message[:status] = 'addition failure'
	return_message.to_json
end

get '/api/output/:id' do
	attribute = params[:id]
	return_message = {}
	if attribute == "1"
		box.doubleSort('category','name')
		return_message[:status] = 'category and name'
	elsif attribute == "2"
		box.rsort('cooktime')
		return_message[:status] = "cooktime"
	elsif attribute == "3"
		box.doubleSort('servings','cooktime')
		return_message[:status] = "servings and cooktime"
	end
	return_message.to_json
end

get '/api/recipes' do
	return_message = {}
	box.rsort('category')
	return_message[:recipe] = box.first.show
	return_message.to_json
end

get '/api/recipes/:attribute' do
	return_message = {}
	attribute = params[:attribute]
	box.rsort(attribute)
	return_message[:status] = "#{attribute} sort view loaded"
	return_message.to_json
end
############### BROWSER VIEWS ##########

get '/' do
	"hello dan"
end

get '/get_recipes' do
	if box.loadRecipes
		redirect 'http://localhost:8080/recipes'
	else
		"something bad happened"
	end
end

get '/empty' do
	box.clear
	redirect 'http://localhost:8080/recipes'
end

get '/output/:id' do
	attribute = params[:id]
	if params[:id] == "1"
		box.doubleSort('category','name')
		attribute = 'category and name'
	elsif params[:id] == "2"
		box.rsort('cooktime')
		attribute = "cooktime"
	elsif params[:id] == "3"
		box.doubleSortDecending('servings','cooktime')
		attribute = "servings and cooktime"
	end
	erb :sorted_recipes, :locals => {:box => box, :attribute => attribute}
end

get '/recipes' do
	return_message = {}
	box.rsort('category')
	erb :sorted_recipes, :locals => {:box => box, :attribute => 'category'}
end

get '/recipes/:attribute' do
	attribute = params[:attribute]
	box.rsort(attribute)
	erb :sorted_recipes, :locals => {:box => box, :attribute => params[:attribute]}
end

get '/recipes/only/:category' do
	subBox = []
	for x in box
		if x.category == params[:category]
			subBox << x
		end
	end
	
	erb :sorted_recipes, :locals => {:attribute => params[:category], :box => subBox}	
end
