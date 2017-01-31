###assumptions!
#categories are one word
#no apostrophes in recipes
#servings are not spelled out

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
				name = line.select(/^([\w\s]+),/m)
				category = line.select(/,([\w\s]+),/)
				cooktime = line.select(/,[.]+,([\d\w\s]+),/)
				servings = line.select(/,([\d]+)$/)
				newRecipe = Recipe.new(name,category,cooktime,servings)
				box << newRecipe
			end
		end
		f = File.open("recipes_pipe", "r") do |f|
			f.each_line do |line|
				name = line.select(/^([\w\s]+)|/m)
				category = line.select(/|([\w\s]+)|/)
				cooktime = line.select(/|[.]+|([\d\w\s]+)|/)
				servings = line.select(/|([\d]+)$/)
				newRecipe = Recipe.new(name,category,cooktime,servings)
				box << newRecipe
			end
		end		
		f = File.open("recipes_space", "r") do |f|
			f.each_line do |line|
				name = line.select(/^'([\w\s]+)'\s/m)
				category = line.select(/\s([\w\s]+)\s/)
				cooktime = line.select(/\s[.]+\s'([\d\w\s]+)'\s/)
				servings = line.select(/\s([\d]+)$/)
				newRecipe = Recipe.new(name,category,cooktime,servings)
				box << newRecipe
			end
		end
	end

	def rsort(attribute)
		if attribute == :name
			self.sort_by{|x,y| x.name <=> y.name}
		elsif attribute == :category
			self.sort_by{|x,y| x.category <=> y.category}
		elsif attribute == :cooktime
			self.sort_by{|x,y| x.cooktime.select(/[\d]{1,4}/) <=> y.cooktime.select(/[\d]{1,4}/)}
		elsif attribute == :servings
			self.sort_by{|x,y| x.servings <=> y.servings}
		else
			return "bad search criteria"
		end
	end

	def addRecipe(name,category,cooktime,servings)
		box << Recipe.new(name, category, cooktime, servings)
	end
end
	

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
		puts "#{@name} - #{@category} - takes #{@cooktime} - Serves #{@servings}"
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
	box.clear ? {status: 'success'}.to_json : {status: 'fail'}.to_json
end

get '/get_recipes' do
	return_message = {}
	if box.loadRecipes
	 return_message[:status] = 'they are not in there!'
	else
		return_message[:status]= 'no work, something went wrong'
	end
	return_message.to_json
end

post '/sort' do
	attribute = JSON.parse(params[:attribute], :symbolize_names => true)
	box.rsort(attribute)
	box.each do 
		each.show
	end
end

post 'recipe' do
	jdata = JSON.parse(params[:data], :symbolize_names => true)
	if jdata.has_key?('name','category','cooktime','servings')
		box.add(jdata[:name],jdata[:category],jdata[:cooktime],jdata[:servings]) ? return_message[:status] = 'success' : return_message[:status] = 'failure'
	end
end

get 'recipes' do
end

get '/recipes/:category/name' do
end

get '/recipes/cook_time' do
end