require 'json'
require 'rest-client'

class BoxClient
	attr_reader :name
	
	def initialize(name)
		@name = name
	end

	def getRecipes
		response = RestClient.get 'http://localhost:8080/get_recipes'
		puts response
	end

	def sortRecipes(attribute)
		response = RestClient.post 'http://localhost:8080/sort', {:params => {:attribute => attribute}} 
		puts response						
	end

	def addRecipe(recipeString)
		name = recipeString[/^([\w\s\d]+)|/]
		category = recipeString[/|([\w\s\d]+)|/]
		cooktime = recipeString[/|([\w\s\d]+)|[.]+$/]
		servings = recipeString[/|([\w\s\d]+)$/]
		response = Restclient.post 'http://localhost:8080/recipe', {:params => {:name => name, :category => category, :cooktime => cooktime, :servings => servings}}
		puts response
	end

	def emptyBox
		response = RestClient.post 'http://localhost:8080/empty_box', data: {}.to_json, accept: :json
		puts response
	end

	def firstRecipe
		response = RestClient.get 'http://localhost:8080/recipes'
		puts response
end

box = BoxClient.new('box')