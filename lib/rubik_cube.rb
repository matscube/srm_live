class RubikCube
	@@ROTATION_TYPES = ["R", "L", "U", "D", "F", "B"]
	@@ROTATION_TURNS = ["", "'", "2"]
	def self.get_scramble size
		(0..size).each do

		end
		return "R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R"
	end
end
