require 'time_manager'

class Contest < ActiveRecord::Base
	def period_string
		from_date.to_s(:date) + " ~ " + to_date.to_s(:date)
	end

	def self.current_contest
		currentDate = TimeManager.now
		Contest.where("from_date <= ? and ? <= to_date", currentDate, currentDate)[0]
	end

	def self.finished_contest_list
		currentDate = TimeManager.now
		Contest.where("to_date <= ?", currentDate)
	end
end
