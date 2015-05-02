# Create new contest

require 'rubik_cube'

namespace :db do

	# Usage: rake "db:contest_seed[2015, 4, 27, 2015, 5, 4]"
  desc "Create new contest"
  task :contest_seed, [:from_year, :from_month, :from_day, :to_year, :to_month, :to_day] => [:environment] do |t, args|
    p "FromDate: " + args[:from_year].to_s + "/" + args[:from_month].to_s + "/" + args[:from_day].to_s + " 00:00"
    p "ToDate: " + args[:to_year].to_s + "/" + args[:to_month].to_s + "/" + args[:to_day].to_s + " 24:00"

		contests = Contest.all.order(:count)

		contest_number = 1
		if contests.count > 0
			contest_number = contests[-1].count + 1
		end
		p "New Contest number: " + contest_number.to_s


		scramble_size = 20
		json = {
			scrambles: [
				RubikCube.get_scramble_string(scramble_size),
				RubikCube.get_scramble_string(scramble_size),
				RubikCube.get_scramble_string(scramble_size)
			]
		}.to_json
		Contest.create(
			count: contest_number,
			from_date: DateTime.new(args[:from_year].to_i, args[:from_month].to_i, args[:from_day].to_i, 0),
			to_date: DateTime.new(args[:to_year].to_i, args[:to_month].to_i, args[:to_day].to_i, 24),
			information: json,
		)
	end
end
