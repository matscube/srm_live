# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Contest.delete_all
Contest.create(
	count: "0",
	from_date: DateTime.new(2015, 2, 27, 0),
	to_date: DateTime.new(2015, 3, 4, 24),
	information: "{}"
)

Contest.create(
	count: "1",
	from_date: DateTime.new(2015, 3, 5, 0),
	to_date: DateTime.new(2015, 3, 11, 24),
	information: "{}"
)

Contest.create(
	count: "2",
	from_date: DateTime.new(2015, 3, 12, 0),
	to_date: DateTime.new(2015, 3, 18, 24),
	information: "{}"
)

User.delete_all