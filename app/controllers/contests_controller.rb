class ContestsController < ApplicationController
  layout 'master'
  def index
    @contest = Contest.current_contest
  end

  def submit
  	@sample = Hoge.new
  	@sample.title = 'hoge'
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
end

class Hoge
	attr_accessor :title, :label
	def model_name
		'Hoge'
	end
end