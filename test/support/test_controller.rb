class TestController < ActionController::Base
  # This TestController is used as a test harness to test the Authenticate concern
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def default_render
    render plain: "#{params[:controller]}##{params[:action]}"
  end
end
