class Record < ActiveRecord::Base
	def self.validate_time_string time
		# 0.99, 59.01
		if time =~ /^([0-9]|[1-5][0-9]).[0-9][0-9]$/
			return true
		# 1:00.00, 59:00.00
		elsif time =~ /^([1-9]|[1-5][0-9]):[0-5][0-9].[0-9][0-9]$/
			return true
		else
			return false
		end
	end
end
