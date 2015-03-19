class ContestsController < ApplicationController
  layout 'master'
  def index
  end

  def submit
  	@sample = Hoge.new
  	@sample.title = 'hoge'
  end

  def list
    @contests = Contest.all
  end

  def show
  end
end

class Hoge
	attr_accessor :title, :label
	def model_name
		'Hoge'
	end
end