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
	}
end
