# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO: reset auto_increment by db env

Contest.delete_all
# if mysql
# Contest.connection.execute('alter sequence contests_id_seq restart with 1')
# else if sqlite
Contest.connection.execute("delete from sqlite_sequence where name='contests'")

json = {
	scrambles: [
		"R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R",
		"R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R",
		"R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R R L' U D2 R L2 B' D2 R"
	]
}.to_json
Contest.create(
	count: "1",
	from_date: DateTime.new(2015, 2, 28, 0),
	to_date: DateTime.new(2015, 3, 4, 24),
	information: json,
)

Contest.create(
	count: "2",
	from_date: DateTime.new(2015, 3, 5, 0),
	to_date: DateTime.new(2015, 3, 11, 24),
	information: json,
)

Contest.create(
	count: "3",
	from_date: DateTime.new(2015, 3, 12, 0),
	to_date: DateTime.new(2015, 3, 18, 24),
	information: json,
)

Contest.create(
	count: "4",
	from_date: DateTime.new(2015, 3, 19, 0),
	to_date: DateTime.new(2015, 3, 25, 24),
	information: json,
)

Contest.create(
	count: "5",
	from_date: DateTime.new(2015, 3, 26, 0),
	to_date: DateTime.new(2015, 4, 1, 24),
	information: json,
)

Contest.create(
	count: "6",
	from_date: DateTime.new(2015, 4, 2, 0),
	to_date: DateTime.new(2015, 4, 8, 24),
	information: json,
)

Contest.create(
	count: "7",
	from_date: DateTime.new(2015, 4, 9, 0),
	to_date: DateTime.new(2015, 4, 15, 24),
	information: json,
)


User.delete_all
User.connection.execute("delete from sqlite_sequence where name='users'")
User.create(
	name: "まっちゃん",
	email: "matscube@gmail.com"
)

User.create(
	name: "みいみいぜみ",
	email: "matscube@gmail.com"
)

User.create(
	name: "つくつくぼうし",
	email: "matscube@gmail.com"
)
 
User.create(
	name: "くまぜみ",
	email: "matscube@gmail.com"
)

Record.delete_all
Record.connection.execute("delete from sqlite_sequence where name='records'")
json = {
	result: [
		{ time: 3 * 60 * 100 + 40 * 100 + 55, DNF: false },
		{ time: 3 * 20 * 100 + 40 * 100 + 55, DNF: true },
		{	time: 1 * 60 * 100 + 20 * 100 + 44,	DNF: false }
	]
}.to_json
Record.create(
	user_id: 1,
	contest_id: 1,
	information: json
)
json = {
	result: [
		{ time: 0 * 60 * 100 + 40 * 100 + 55, DNF: true },
		{ time: 1 * 20 * 100 + 10 * 100 + 55, DNF: true },
		{	time: 2 * 60 * 100 + 20 * 100 + 44,	DNF: false }
	]
}.to_json
Record.create(
	user_id: 2,
	contest_id: 1,
	information: json
)
json = {
	result: [
		{ time: 0 * 60 * 100 + 55 * 100 + 55, DNF: false },
		{ time: 0 * 20 * 100 + 58 * 100 + 55, DNF: false },
		{	time: 0 * 60 * 100 + 49 * 100 + 44,	DNF: false }
	]
}.to_json
Record.create(
	user_id: 3,
	contest_id: 1,
	information: json
)

json = {
	result: [
		{ time: 0 * 60 * 100 + 55 * 100 + 55, DNF: true },
		{ time: 0 * 20 * 100 + 58 * 100 + 55, DNF: true },
		{	time: 0 * 60 * 100 + 49 * 100 + 44,	DNF: true }
	]
}.to_json
Record.create(
	user_id: 4,
	contest_id: 1,
	information: json
)

json = {
	result: [
		{ time: 0 * 60 * 100 + 55 * 100 + 55, DNF: true },
		{ time: 0 * 20 * 100 + 58 * 100 + 55, DNF: true },
		{	time: 0 * 60 * 100 + 49 * 100 + 44,	DNF: true }
	]
}.to_json
Record.create(
	user_id: 3,
	contest_id: 5,
	information: json
)

json = {
	result: [
		{ time: 0 * 60 * 100 + 55 * 100 + 55, DNF: true },
		{ time: 0 * 20 * 100 + 58 * 100 + 55, DNF: true },
		{	time: 0 * 60 * 100 + 49 * 100 + 44,	DNF: true }
	]
}.to_json
Record.create(
	user_id: 3,
	contest_id: 6,
	information: json
)
