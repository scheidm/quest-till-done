class NotesController < NodesController
  def index
    @notes = Note.all
  end

  def show
    @note = Note.find(params[:id])
  end

  def new
    if session[:state].nil? || session[:state].casecmp('Start') == 0
      @notes = Note.all
       render action: 'index', note: @notes, notice: 'No active pomodoro.'
    end

    @pomodoro = Pomodoro.last
    @pomodoro = Pomodoro.create if @pomodoro.nil? || @pomodoro.created_at<30.minutes.ago
    @pomodoro.delay({:run_at => 30.minutes.from_now}).close
    @note = Note.new()
    @note.pomodoro_id = @pomodoro.id
  end

  def create
    @note = Note.new(note_params)

    @note.created_at = DateTime.now

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @note }
      else
        format.html { render action: 'new'}
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def note_params
    params.require(:note).permit(:description, :pomodoro_id, :pomodoro)
  end
end
