###assumptions!
#categories are one word
#no apostrophes in recipes
#servings are not spelled out

#RecipeArray should store recipes as named Hashes

require 'sinatra'

#Recipe Box Class
class RecipeBox < Array

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

##### API stuff #####
set :port, 8080
set :environment, :production

get '/get_recipes' do	
end

post '/sort' do
	attribute = JSON.parse(params[:attribute], :symbolize_names => true)
	recipe_box.rsort(attribute)
	recipe_box.each do each.show
	end
end
