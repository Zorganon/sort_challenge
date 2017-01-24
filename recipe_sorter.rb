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

	def getRecipes
		response = RestClient.get 'http://localhost:8080/get_recipes'
	end

	def sortRecipes(attribute)
		if self.empty?
			puts "Box is empty dumbass."
		else
			response = RestClient.post 'http://localhost:8080/sort', {:params => {:attribute => attribute}} 
			puts response				
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
end
	
box = RecipeBox.new

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


##### sinatra stuff #####
set :port, 8080
set :environment, :production

get '/' do
	"hello dan"
end

post '/empty_box' do
	box.clear
	"k it's empty now"
end

get '/get_recipes' do	
	"I'm adding all the recipes to the box now"
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

post '/sort' do
	attribute = JSON.parse(params[:attribute], :symbolize_names => true)
	box.rsort(attribute)
	box.each do each.show
	end
end
