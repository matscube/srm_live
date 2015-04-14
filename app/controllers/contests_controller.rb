require 'time_manager'

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
    @contests = Contest.all.order(:count).reverse_order
    @users = User.all.index_by(&:id)
  end

  # GET /show/1
  def show
    id = params[:id]
    @contest = Contest.where(id: id)[0]
    if @contest.blank?
      redirect_to action: 'list'
    else
      @result = Record.get_result @contest.id
      @users = User.all.index_by(&:id)
    end
  end

  # PUT /register
  def register
    p params

    valid = true
    record = Record.new

    # Contest
    contest_count = params["contest_count"]
    # TODO: validate contest_count
    contest = Contest.where(count: contest_count)[0]
    if contest.present?
      record.contest_id = contest.id
    else
      valid = false
    end

    # User
    user_name = params["registrant"]
    if user_name == ""
      valid = false
      user = User.new
    else
      user = User.where(name: user_name)[0]
      if user.blank?
        user = User.create(
          name: user_name,
          email: "",
        )
      end
      record.user_id = user.id
    end

    # Time
    times = []
    params["time"].each do |time, index|
      if Record.validate_time_string time
        t = Record.get_time_from_string time
        times.push t
      else
        valid = false
        times.push 0
      end
    end
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

    result = []
    result.push ({ time: times[0], DNF: dnfs[0] })
    result.push ({ time: times[1], DNF: dnfs[1] })
    result.push ({ time: times[2], DNF: dnfs[2] })
    


    if valid.blank?
      flash[:notice] = "入力形式に誤りがあります"
      @submit_info = SubmitInformation.create_with_params params
      render 'submit'
    else


      json = {
        result: result,
        comment: params["comment"],
      }.to_json
      record.contest_id = 7
      record.information = json
      record.save

      redirect_to :action => 'index'
    end
  end
end

class SubmitInformation
	attr_accessor :title, :label, :comment
  def self.create_with_params params
    res = SubmitInformation.new
    res.comment = "Re comment"
    return res
  end
end