module DeliberationsHelper
	def valid_committees
		valid = Array.new
		for c in Committee.all
			if not (c.name.include? "Exec" or c.name.include? "General" or c.name.include? "Internal")
				valid << c
			end
		end
		return valid
	end
end
