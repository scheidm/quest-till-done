class NotesController < NodesController
  def index
    @notes = Note.all
  end
end
