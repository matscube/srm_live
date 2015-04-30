# Create new contest

require 'rubik_cube'

namespace :db do

	# Usage: rake "db:contest_seed[2015, 4, 27]"
  desc "Create new contest"
  task :contest_seed, [:year, :month, :day] => [:environment] do |t, args|
    p "FromDate: " + args[:year].to_s + "/" + args[:month].to_s + "/" + args[:day].to_s + " 00:00"

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
			from_date: DateTime.new(2015, 2, 28, 0),
			to_date: DateTime.new(2015, 3, 4, 24),
			information: json,
		)
	end
end
