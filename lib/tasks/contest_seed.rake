# Create new contest

namespace :db do

  desc "Create new contest"
  task :contest_seed => [:environment] {
		contests = Contest.all.order(:count)
		p contests.count
		if contests.count > 0
		else
		end
	}
end
