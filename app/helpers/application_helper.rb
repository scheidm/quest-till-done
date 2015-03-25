module ApplicationHelper
  # when generating user alerts, sets the alert dialog to the right value
  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
      when :warning then "alert alert-warning"
    end
  end

  def trunc(string, length = 25, split=0.8)
    before=length*split
    after=length-before
    string.size > length+5 ? [string[0,before],string[-after,after]].join("...") : string
  end

  def new_record_link(active_quest)
      if(active_quest)
        link_to content_tag(:span, nil, class: 'glyphicon glyphicon-plus-sign'), new_record_path(:quest_id => active_quest.id), :remote => true, :class => 'btn btn-success', :'data-placement' => 'bottom', :'data-toggle' => 'modal', :title => 'Add record to quest', 'data-target' => '#new-record-modal.modal'
      else
        link_to content_tag(:span, nil, class: 'glyphicon glyphicon-plus-sign'), nil, :remote => true, :class => 'btn btn-success', :'data-placement' => 'bottom', :title => 'No active quest', 'disabled' => true

          #link_to '', '', :class => 'btn btn-success', :'data-placement' => 'bottom', :title => 'No active Quest', 'disabled' => true
      end
  end

  def render_timer_button
    state = true
    if(@user.timer.mode == 'manual')
      state = false
    end
    #container = content_tag :div, :class => 'btn-group btn-group-sm'
    play = button_tag content_tag(:span, nil, class: 'glyphicon glyphicon-play'), :id => 'startBtn', :class => 'btn btn-success', :'data-placement' => "bottom", :'data-toggle' => "tooltip", :title => "Start countdown"
    pause = button_tag content_tag(:span, nil, class: 'glyphicon glyphicon-pause'), :id => 'stopBtn', :class => 'btn btn-warning', :'data-placement' => "bottom", :'data-toggle' => "tooltip", :title => "Pause countdown"
    stop = button_tag content_tag(:span, nil, class: 'glyphicon glyphicon-stop'), :id => 'resetBtn', :class => 'btn btn-danger', :'data-placement' => "bottom", :'data-toggle' => "tooltip", :title => "Reset countdown"
    extend = button_tag content_tag(:span, nil, class: 'glyphicon glyphicon-plus'), :id => 'extendBtn', :class => 'btn btn-info', :'data-placement' => "bottom", :'data-toggle' => "tooltip", :title => "Extend Encounter", :disabled => state
    rest = button_tag content_tag(:span, nil, class: 'glyphicon glyphicon-bell'), :id => 'restBtn', :class => 'btn btn-primary', :'data-placement' => "bottom", :'data-toggle' => "tooltip", :title => "Take a break", :disabled => state
    arr = [play, pause, stop, extend, rest]
    content_tag :div, :class => 'btn-group btn-group-sm' do
      arr.each do |content|
        concat content
      end
    end
  end

  def render_timer_mode
    auto_class = 'mode-toggle btn btn-sm'
    auto_class << ((@timer.mode == 'auto') ? ' btn-primary' : ' btn-default')
    manual_class = 'mode-toggle btn btn-sm'
    manual_class << ((@timer.mode == 'manual') ? ' btn-primary' : ' btn-default')
    content_tag :div, :class => 'btn-group btn-toggle', :id => 'mode-toggle-group' do
        concat button_tag 'Auto', :id => 'autoModeBtn', :class => auto_class, :value => 'auto'
        concat button_tag 'Manual', :id => 'manualModeBtn', :class => manual_class, :value =>'manual'
    end
  end
end
