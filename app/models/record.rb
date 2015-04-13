class Record < ActiveRecord::Base
	MAX_TIME = 100 * 60 * 60 * 100 # 100 hour

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

	def self.get_time_from_string time_string
		exp1 = /^([0-9]|[1-5][0-9]).([0-9][0-9])$/
		exp2 = /^([1-9]|[1-5][0-9]):([0-5][0-9]).([0-9][0-9])$/

		if time_string =~ exp1
			res1 = exp1.match time_string
			return res1[1].to_i * 100 + res1[2].to_i
		elsif time_string =~ exp2
			res2 = exp2.match time_string
			return res2[1].to_i * 100 * 60 + res2[2].to_i * 100 + res2[3].to_i
		else
			return false
		end
	end

	def self.time_label time
		if time > MAX_TIME
			time = MAX_TIME
		end
		h = time / (60 * 60 * 100)
		m = (time / (60 * 100)) % 60
		s = (time / 100) % 60
		cs = time % 100

		res = ""
		cs = format("%02d", cs)
		res = cs.to_s

		if s > 0
			s = format("%02d", s) if m > 0
			res = s.to_s + ":" + res
		end

		if m > 0
			m = format("%02d", m) if h > 0
			res = m.to_s + ":" + res
		end

		res = h.to_s + ":" + res if h > 0

		res
	end

	def self.get_summary contest_id
		records = Record.where(contest_id: contest_id)
		users = User.all.index_by(&:id)

		if records.blank?
			return nil
		end

		winner_id = -1
		best_time = -1
		records.each do |record|
			data = JSON.parse(record.information)
			res = data["result"]
			res.each do |res|
				if res["DNF"].blank?
					if best_time == -1
						best_time = res["time"]
						winner_id = record.user_id
					elsif best_time > res["time"]
						best_time = res["time"]
						winner_id = record.user_id
					end
				end
			end
		end

		if winner_id == -1
			return nil
		else
			return {
				winner_id: winner_id,
				winner_time_label: self.time_label(best_time),
			}
		end
	end

	def self.get_result contest_id
		records = Record.where(contest_id: contest_id)
		users = User.all.index_by(&:id)

		if records.blank?
			return []
		end

		user_plus = []
		user_dnf = []
		records.each do |record|
			data = JSON.parse(record.information)
			res = data["result"]

			# calc best_time
			best_time = -1
			res.each do |res|
				if res["DNF"].blank?
					if best_time == -1
						best_time = res["time"]
					else
						best_time = [best_time, res["time"]].min
					end
				end
			end

			if best_time == -1
				data = {
					user_id: record.user_id,
					best_time: -1,
					best_time_label: "DNF",
					DNF: true,
				}
				result = []
				res.each do |r|
					if r["DNF"].present?
						result.push({
							time: -1,
							time_label: "DNF",
							DNF: true,
						})
					else
						result.push({
							time: r["time"],
							time_label: self.time_label(r["time"]),
							DNF: false,
						})
					end
				end
				data[:result] = result

				user_dnf.push data
			else
				data = {
					user_id: record.user_id,
					best_time: best_time,
					best_time_label: self.time_label(best_time),
					DNF: false,
					result: res,
				}
				result = []
				res.each do |r|
					if r["DNF"].present?
						result.push({
							time: -1,
							time_label: "DNF",
							DNF: true,
						})
					else
						result.push({
							time: r["time"],
							time_label: self.time_label(r["time"]),
							DNF: false,
						})
					end
				end
				data[:result] = result
				user_plus.push data
			end
		end

		user_plus.sort! { |a, b| a[:best_time] <=> b[:best_time] }

		# calc order
		order = 0
		before_time = -1
		user_plus.each do |u|
			if u[:best_time] == before_time
				u[:order] = order
			else
				order += 1
				before_time = u[:best_time]
				u[:order] = order
			end
		end

		order += 1
		user_dnf.each do |u|
			u[:order] = order
		end

		user_plus + user_dnf

#		h = []
#		h.push({time: 300}, {time: 200}, {time: 400})
#		b.sort { |a,b| a[:time]<=>b[:time]}

	end
end
