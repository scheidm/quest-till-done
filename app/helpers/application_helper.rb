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

end
