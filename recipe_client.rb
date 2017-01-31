require 'json'
require 'rest-client'

class BoxClient
	attr_reader :name
	
	def initialize(name)
		@name = name
	end

	def getRecipes
		response = RestClient.get 'http://localhost:8080/get_recipes', {params: {:name => @name}}
		puts response
	end

	def sortRecipes(attribute)
		if self.empty?
			puts "Box is empty dumbass."
		else
			response = RestClient.post 'http://localhost:8080/sort', {:params => {:attribute => attribute}} 
			puts response				
		end
	end

	def addRecipe(recipeString)
		name = recipeString.select(/^([\w\s\d]+)|/)
		category = recipeString.select(/|([\w\s\d]+)|/)
		cooktime = recipeString.select(/|([\w\s\d]+)|[.]+$/)
		servings = recipeString.select(/|([\w\s\d]+)$/)
		response = Restclient.post 'http://localhost:8080/recipe', {:params => {:name => name, :category => category, :cooktime => cooktime, :servings => servings}}
		puts response
	end

	def emptyBox
		response = RestClient.post 'http://localhost:8080/empty_box', data: {}.to_json, accept: :json
		puts response
	end
end