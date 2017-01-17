

class RecipeSorterApp
@@recipe_counter = 0
	def fileGetter

		this method should take the recipe files and put them into an array which can be accessed by other methods?
	end

	def recipesIn
		File.foreach('recipes_pipe') { |line| 
			string_line = line.split('|')
			recipe[@@recipe_counter] = saveRecipe(string_line)
			@@recipe_counter += 1

		}
		File.foreach('recipes_comma') { |line|
			string_line = line.split(',')
			saveRecipe(string_line)
		}
		File.foreach('recipes_space') { |line|
			new_record = Hash.new 
			new_record[name] = line.match(/^'[\w\s]+'/)
			new_record[servings] = line.match(/'[\w\s]+'\w+$/)
		}
	end

	def saveRecipe(line)
		new_record = Hash.new
		new_record[name] = line.shift
		new_record[category] = line.shift
		new_record[cook_time] = line.shift
		new_record[servings] = line.shift
		return new_record
	end

