ENV['RACK_ENV'] = 'test'

require 'recipe_client.rb'
require 'test/unit'
require 'rack/test'

class RecipeTests < Test::Unit::TestCase
	include Rack::Test::Methods

	def app
		sinatra::application
	end

	def test_box_creation
		box = BoxClient.new('box')
		box.getRecipes
		
		assert_block( failure_message = "reading comma recipes failed") do
			box.each do 
				if each.include?("borscht")
					return true
				end
			end
		end
		assert_block(failure_message = "reading pipe recipes failed") do
			box.each do
				if each.include?("cream cheese wontons")
					return true
				end
			end
		end
		assert_block(failure_message = "reading space recipes failed") do
			box.each do
				if each.include?("whale biryani")
					return true
				end
			end
		end
	end

	def test_sort_by_name
		box = BoxClient.new('box')
		box.getRecipes
		box.sortRecipes(name)
	end

end