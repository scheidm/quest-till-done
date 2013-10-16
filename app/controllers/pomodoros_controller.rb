class PomodorosController < ApplicationController
  def index
    @pomos = Pomodoro.all
  end

  def new
  end

  def show
  end
end
