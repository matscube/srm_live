class ContestsController < ApplicationController
  layout 'master'
  def index
    @contest = Contest.current_contest

    if @contest.present?
      @records = Record.where(contest_id: @contest.id)
      @users = User.all.index_by(&:id)
    else
      @records = []
    end
  end

  def submit
    @contest = Contest.current_contest
  	@submit_info = SubmitInformation.new
  end

  def list
    @contests = Contest.finished_contest_list.order(:count).reverse_order
    @users = User.all.index_by(&:id)
  end

  def schedule
    @contests = Contest.scheduled_contest_list.order(:count)
  end

  # GET /show/1
  def show
    id = params[:id]
    @contest = Contest.where(id: id)[0]
    if @contest.blank?
      redirect_to action: 'list'
    elsif !@contest.finished?
      redirect_to action: 'index'
    else
      @result = Record.get_result @contest.id
      @users = User.all.index_by(&:id)
    end
  end

  # PUT /register
  def register
    p params
    if SubmitInformation.validate params
      SubmitInformation.register params
      redirect_to :action => 'index'
    else
      flash[:notice] = "入力形式に誤りがあります"
      @contest = Contest.current_contest
      @submit_info = SubmitInformation.create_with_params params
      render 'submit'
    end
  end

end

class SubmitInformation
  attr_accessor :dnf_checked, :time, :registrant, :comment

  def initialize
    @registrant = ""
    @dnf_checked = ["", "", ""]
    @time = ["", "", ""]
    @comment = ""
  end

  def self.create_with_params params
    res = SubmitInformation.new

    res.registrant = params["registrant"]
    res.dnf_checked = []
    (1..3).each do |index|
      key = "DNF-#{index}"
      if params[key].present?
        res.dnf_checked.push "checked"
      else
        res.dnf_checked.push ""
      end
    end
    res.time = params["time"]
    res.comment = params["comment"]
    return res
  end

  # TODO: show error detail
  def self.validate params
    # Contest
    contest_count = params["contest_count"]
    contest = Contest.new
    if contest_count == ""
      p "ERROR: contest count is null"
      return false
    else
      contest = Contest.where(count: contest_count)[0]
      if contest.blank?
        p "ERROR: contest_count#{contest_count} is nowhere"
        return false
      end
    end

    # User
    user_name = params["registrant"]
    if user_name == ""
      p "ERROR: user_name is null"
      return false
    end
    user = User.where(name: user_name)[0]
    if user.present?
      if Record.where(contest_id: contest.id, user_id: user.id)[0].present?
        p "ERROR: user(id: #{user.id}) has already submitted"
        return false
      end
    end

    # Time
    dnfs = []
    (1..3).each do |index|
      key = "DNF-#{index}"
      if params[key].present?
        p "DNF: #{index}"
        dnfs.push true
      else
        dnfs.push false
      end
    end
    params["time"].each_with_index do |time, index|
      unless Record.validate_time_string time
        next if dnfs[index]
        p "ERROR: record string format is invalid: #{time}"
        return false
      end
    end
  end

  def self.register params
    record = Record.new

    # Contest
    contest_count = params["contest_count"]
    contest = Contest.where(count: contest_count)[0]
    record.contest_id = contest.id

    # User
    user_name = params["registrant"]
    user = User.where(name: user_name)[0]
    if user.blank?
      user = User.create(
        name: user_name,
        email: "",
      )
    end
    record.user_id = user.id

    # Time
    dnfs = []
    (1..3).each do |index|
      key = "DNF-#{index}"
      if params[key].present?
        p "DNF: #{index}"
        dnfs.push true
      else
        dnfs.push false
      end
    end
    times = []
    params["time"].each_with_index do |time, index|
      if dnfs[index]
        times.push -1
      else
        t = Record.get_time_from_string time
        times.push t
      end
    end

    result = []
    result.push ({ time: times[0], DNF: dnfs[0] })
    result.push ({ time: times[1], DNF: dnfs[1] })
    result.push ({ time: times[2], DNF: dnfs[2] })

    json = {
      result: result,
      comment: params["comment"],
    }.to_json
    record.information = json
    record.save
  end
end