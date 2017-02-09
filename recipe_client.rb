require 'json'
require 'rest-client'

class BoxClient
	attr_accessor :name, :message
	
	def initialize(name)
		@name = name
		@message = ""
	end

	def getRecipes
		response = RestClient.get 'http://localhost:8080/get_recipes'
		
		@message = JSON.parse(response)
	end

	def sortRecipes(attribute)
		response = RestClient.post 'http://localhost:8080/sort', data: {attribute: attribute}.to_json, accept: :json

		@message = JSON.parse(response)
	end

	def addRecipe(recipeString)
		#takes a pipe delimited recipe
		name = recipeString[/^([\w\s\d]+)|/]
		category = recipeString[/|([\w\s\d]+)|/]
		cooktime = recipeString[/|([\w\s\d]+)|[.]+$/]
		servings = recipeString[/|([\w\s\d]+)$/]
		response = Restclient.post 'http://localhost:8080/recipe', {:params => {:name => name, :category => category, :cooktime => cooktime, :servings => servings}}
		@message = JSON.parse(response)
		puts @message
	end

	def emptyBox
		response = RestClient.post 'http://localhost:8080/empty_box', data: {}.to_json, accept: :json
		
		@message = JSON.parse(response)
	end

	def firstRecipe
		response = RestClient.get 'http://localhost:8080/recipes'
		
		@message = JSON.parse(response)
	end
end
