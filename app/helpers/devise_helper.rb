module DeviseHelper
  # Will generate a list of error messages for display when having login issues
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
  <div class="alert alert-danger alert-dismissable devise-alert centered fade in" style>
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    #{messages}
  </div>
    HTML

    html.html_safe
  end

  # Will appropriately format user login notifications
  def flash_class_devise(level)
    case level
      when :notice then "alert alert-info devise-alert centered"
      when :success then "alert alert-success devise-alert centered"
      when :error then "alert alert-danger devise-alert centered"
      when :alert then "alert alert-danger devise-alert centered"
    end
  end
end
