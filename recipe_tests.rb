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
		
		assert_equal("recipes loaded", mybox.message["status"])
	end

	def test_box_empties
		mybox = BoxClient.new('Dans box')
		mybox.getRecipes
		mybox.emptyBox

		assert_equal("empty success", mybox.message["status"])
	end

	def test_sort_by_name
		mybox = BoxClient.new('Dans box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.sortRecipes('name')
		
		assert_equal("apple pie", mybox.message["recipe"])
		mybox.emptyBox
	end

	def test_sort_by_category
		mybox = BoxClient.new('Dans box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.sortRecipes('category')
		
		assert_equal("dessert", mybox.message["recipe"])
	end

	def test_sort_by_time
		mybox = BoxClient.new('da box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.sortRecipes('cooktime')
		
		assert_equal(8, mybox.message["recipe"])
	end

	def test_recipe_adding
		mybox = BoxClient.new('da box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.addRecipe("test recipe|aaa|5 minutes|9")

		assert_equal("addition successful", mybox.message["status"])
	end

end