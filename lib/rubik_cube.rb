class RubikCube
	@@ROTATION_TYPES = ["R", "L", "U", "D", "F", "B"]
	@@ROTATION_TURNS = ["", "'", "2"]
	def self.get_scramble size
		scramble = []
		before_rtype_id = -1
		(0..size).each do
			rtype_size = @@ROTATION_TYPES.size
			rtype_id = rand(rtype_size)

			if before_rtype_id == rtype_id
				rtype_id = (rtype_id + 1) % rtype_size
			end
			before_rtype_id = rtype_id

			rturn_size = @@ROTATION_TYPES.size
			rturn_id = rand(rturn_size)

			turn = @@ROTATION_TYPES[rtype_id].to_s + @@ROTATION_TURNS[rturn_id].to_s
			scramble.push turn
		end
		return scramble
	end
end
