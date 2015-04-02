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

  # PUT /register
  def register
    p params

    if params["hidden"].present?
      flash[:notice] = "入力形式に誤りがあります"
      render 'submit'
    else
      redirect_to :action => 'index'
    end
  end
end

class Hoge
	attr_accessor :title, :label
	def model_name
		'Hoge'
	end
end