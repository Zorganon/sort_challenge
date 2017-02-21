
This is the Documentation and Instructions for use of the Recipe Sorter Sinatra App.

(0. clone from github: https://github.com/Zorganon/sort_challenge)

Run the App:
	In a terminal in the proper directory (assuming sinatra isn't already installed) run:  
		$ gem install sinatra
		$ gem install thin
		$ ruby './recipe_sorter.rb'

To use the API (after starting the app)
	a. $irb
	b. irb> require './recipe_client.rb'
	c. create a local 'box' object to communicate w/ app e.g.
		irb> myBox = BoxClient.new('fred') (the name variable is not used at all)
	d. Methods to use
		READ IN : myBox.getRecipes
		EMPTY : myBox.emptyBox
		ADD : myBox.addRecipe("pipe|delimited|recipe|string")
		SORT : myBox.sortRecipes(attribute) - attribute can be 'name', 'category', 'cooktime', or 'servings'

To run the tests
	$ ruby './recipe_tests.rb'

Browser views:
	Once the app is running, you can navigate to:

		1. localhost:8080/get_recipes - reads in recipes and redirects to /recipes to display them.

		2. localhost:8080/output/:id - where :id is 1, 2, or 3
			This sorts the list by:
				1. Category then Name
				2. Cooktime
				3. Servings, Cooktime