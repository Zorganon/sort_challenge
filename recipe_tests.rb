ENV['RACK_ENV'] = 'test'

require 'recipe_sorter.rb'
require 'recipe_client.rb'
require 'test/unit'
require 'rack/test'

class RecipeTests < Test::Unit::TestCase
	include Rack::Test::Methods

	def app
		sinatra::application
	end

	def test_adding_a_recipe
		post '/recipe'
	end
end