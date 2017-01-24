
require 'json'
require 'rest-client'

class BoxClient
	attr_reader :name
	
	def initialize(name)
		@name = name
	end

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
end