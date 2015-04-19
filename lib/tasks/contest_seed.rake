# Create new contest

namespace :db do

  desc "Create new contest"
  task :contest_seed => [:environment] {
		contests = Contest.all.order(:count)

		contest_number = 1
		if contests.count > 0
			contest_number = contests[-1].count + 1
		end
		p "New Contest number: " + contest_number.to_s

		json = {
			scrambles: [
				"R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R",
				"R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R",
				"R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R"
			]
		}.to_json
		Contest.create(
			count: contest_number,
			from_date: DateTime.new(2015, 2, 28, 0),
			to_date: DateTime.new(2015, 3, 4, 24),
			information: json,
		)
	}
end
