module PrioritiesHelper
  def active_campaign(id)
    current_id = params[:id]
    'active' if current_id.to_i == id
  end
end
