class TimeManager
	DEBUG = false
	def self.now
		if DEBUG
			DateTime.new(2015, 4, 2, 0)
		else
			now = DateTime.now
		end
	end
end