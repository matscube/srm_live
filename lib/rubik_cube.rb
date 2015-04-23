class RubikCube
	@@ROTATIONS = ["R", "R'", "R2", "L", "L'", "L2", "U", "U'", "U2", "D", "D'", "D2", "F", "F'", "F2", "B", "B'", "B2"]
	def self.get_scramble size
		sz = @@ROTATIONS.count
		return "R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R"
	end
end
