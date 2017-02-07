ENV['RACK_ENV'] = 'test'

require './recipe_client.rb'
require 'test/unit'
require 'rack/test'

class RecipeTests < Test::Unit::TestCase
	include Rack::Test::Methods

	#def app
	#	sinatra::application
	#end

	def test_client_not_nil
		mybox = BoxClient.new('Dans box')

		assert_not_equal(nil, mybox)
	end


	def test_recipe_read_in
		mybox = BoxClient.new('Dans box')
		mybox.getRecipes
		
		assert_equal("they are in there!", mybox.message["status"])
	end

	def test_box_empties
		mybox = BoxClient.new('Dans box')
		mybox.getRecipes
		mybox.emptyBox

		assert_equal("success", mybox.message["status"])
	end

	def test_sort_by_name
		mybox = BoxClient.new('Dans box')
		mybox.getRecipes
		mybox.sortRecipes(name)
		mybox.firstRecipe

		assert_equal("apple pie", mybox.message["recipe"])
	end

end