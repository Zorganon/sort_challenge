require 'json'
require 'rest-client'

class BoxClient
	attr_accessor :name, :message
	
	def initialize(name)
		@name = name
		@message = ""
	end

	def getRecipes
		response = RestClient.get 'http://localhost:8080/api/get_recipes'
		
		@message = JSON.parse(response)
	end

	def sortRecipes(attribute)
		response = RestClient.post 'http://localhost:8080/api/sort', data: {attribute: attribute}.to_json, accept: :json

		@message = JSON.parse(response)
	end

	def addRecipe(recipeString)
		#takes a pipe delimited recipe
		response = RestClient.post 'http://localhost:8080/api/recipe', data: {:recipe => recipeString}.to_json, accept: :json
		@message = JSON.parse(response)
	end

	def emptyBox
		response = RestClient.post 'http://localhost:8080/api/empty_box', data: {}.to_json, accept: :json
		
		@message = JSON.parse(response)
	end

	def firstRecipe
		response = RestClient.get 'http://localhost:8080/api/recipes'
		
		@message = JSON.parse(response)
	end

	def showRecipesBy(attribute)
		response = RestClient.get "http://localhost:8080/api/recipes/#{attribute}"

		@message = JSON.parse(response)
	end

	def outputView(num)
		response = RestClient.get "http://localhost:8080/api/output/#{num}"
		@message = JSON.parse(response)
	end

end

