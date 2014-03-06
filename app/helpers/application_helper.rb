module ApplicationHelper
  # when generating user alerts, sets the alert dialog to the right value
  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end

  def new_record_link(active_quest)
      s = active_quest
      if(active_quest)
        link_to content_tag(:span, nil, class: 'glyphicon glyphicon-plus-sign'), new_record_path(:quest_id => active_quest.id), :remote => true, :class => 'btn btn-success', :'data-placement' => 'bottom', :'data-toggle' => 'modal', :title => 'Add Quest', 'data-target' => '#new-record-modal.modal'
      else
        link_to content_tag(:span, nil, class: 'glyphicon glyphicon-plus-sign'), nil, :remote => true, :class => 'btn btn-success', :'data-placement' => 'bottom', :title => 'No active quest', 'disabled' => true

          #link_to '', '', :class => 'btn btn-success', :'data-placement' => 'bottom', :title => 'No active Quest', 'disabled' => true
      end
  end
end
