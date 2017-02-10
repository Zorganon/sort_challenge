ENV['RACK_ENV'] = 'test'

require './recipe_client.rb'
require 'test/unit'
require 'rack/test'

class RecipeTests < Test::Unit::TestCase
	include Rack::Test::Methods

	#def app
	#	sinatra::application
	#end

	def test1_client_not_nil
		mybox = BoxClient.new('Dans box')

		assert_not_equal(nil, mybox)
	end


	def test2_recipe_read_in
		mybox = BoxClient.new('Dans box')
		mybox.getRecipes
		
		assert_equal("recipes loaded", mybox.message["status"])
	end

	def test3_box_empties
		mybox = BoxClient.new('Dans box')
		mybox.getRecipes
		mybox.emptyBox

		assert_equal("empty success", mybox.message["status"])
	end

	def test4_sort_by_name
		mybox = BoxClient.new('Dans box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.sortRecipes('name')
		
		assert_equal("apple pie", mybox.message["recipe"])
		mybox.emptyBox
	end

	def test5_sort_by_category
		mybox = BoxClient.new('Dans box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.sortRecipes('category')
		
		assert_equal("dessert", mybox.message["recipe"])
	end

	def test6_sort_by_time
		mybox = BoxClient.new('da box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.sortRecipes('cooktime')
		
		assert_equal(8, mybox.message["recipe"])
	end

	def test7_recipe_adding
		mybox = BoxClient.new('a box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.addRecipe('test recipe|aaa|5 minutes|9')

		assert_equal("addition success", mybox.message["status"])
	end

	def test8_recipe_add_and_sort
		mybox = BoxClient.new('a box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.addRecipe('test recipe|aaa|5 minutes|9')
		mybox.sortRecipes('category')

		assert_equal("aaa", mybox.message["recipe"])
	end

	def test9_hits_output_view_1
		mybox = BoxClient.new('a box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.outputView(1)

		assert_equal("category and name", mybox.message["status"])
	end

	def test10_hits_output_view_2
		mybox = BoxClient.new('a box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.outputView(2)

		assert_equal("cooktime", mybox.message["status"])
	end

	def test11_hits_output_view_3
		mybox = BoxClient.new('a box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.outputView(3)

		assert_equal("servings and cooktime", mybox.message["status"])
	end

	def test12_sort_by_params_name
		mybox = BoxClient.new('a box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.showRecipesBy('name')

		assert_equal("name sort view loaded", mybox.message["status"])
	end

	def test12_sort_by_params_name
		mybox = BoxClient.new('a box')
		mybox.emptyBox
		mybox.getRecipes
		mybox.showRecipesBy('name')

		assert_equal("name sort view loaded", mybox.message["status"])
	end

end