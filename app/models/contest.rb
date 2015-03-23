class Contest < ActiveRecord::Base
	def period_string
		from_date.to_s(:date) + " ~ " + to_date.to_s(:date)
	end
end
