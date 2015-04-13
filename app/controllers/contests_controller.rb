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

    params["time"].each do |time|
      valid = false unless Record.validate_time_string time
    end
    (1..3).each do |index|
      key = "DNF-#{index}"
      if params[key].present?
        p "DNF: #{index}"
      else

      end
    end

    if valid.blank?
      flash[:notice] = "入力形式に誤りがあります"
      @submit_info = SubmitInformation.create_with_params params
      render 'submit'
    else

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