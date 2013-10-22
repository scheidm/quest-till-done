class NotesController < NodesController
  def index
    @notes = Note.all
  end

  def new
    @pomodoro = Pomodoro.last
    @pomodoro = Pomodoro.create if @pomodoro.created_at<30.minutes.ago
    @pomodoro.delay({:run_at => 30.minutes.from_now}).close
    @note = Note.new
    @note.pomodoro=@pomodoro
  end
end
