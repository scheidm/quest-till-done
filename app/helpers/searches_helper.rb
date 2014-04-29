module SearchesHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected
    # Will link to the specified page, unless the page is the same as the
    # current page
    # @param page [Integer] the page to find the link
    def page_number(page)
      unless page == current_page
        link(page, page, :rel => rel_value(page))
      else
        link(page, "#", :class => 'active')
      end
    end

    # Will define a list item based on the pagination
    def gap
      text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
      %(<li class="disabled"><a>#{text}</a></li>)
    end

    # Will generate a button for the next page based on current pagination data
    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], 'next')
    end


    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :class => classname)
      else
        link(text, "#", :class => classname + ' disabled')
      end
    end

    # Will create a paginated container for specified html
    # @param html [String] an html-formatted string
    def html_container(html)
      tag(:ul, html, :class => 'pagination')
    end
    private
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = rel_value(target)
        target = url(target)
      end
      unless target == "#"
        attributes[:href] = target
      end
      classname = attributes[:class]
      attributes.delete(:classname)
      tag(:li, tag(:a, text, attributes), :class => classname)
    end
  end

  # Will format the status for results of the quest and campaign classes
  # @param result [String] class object
  # @return [Html] status tag for quest/campaigns
  def render_status_tag(result)
    if ['Quest', 'Campaign'].include? result.class.name
      status = ''
      case result.status
        when 'Open' then status = 'label label-primary'
        when 'In Progress' then status = 'label label-success'
        when 'Closed' then status = 'label label-default'
      end
      content_tag(:span, result.status, :class => status)
    end
  end

  # Will return css class for the result
  # @param result [String] class name
  # @return [String] css class
  def render_row_class(result)
    case result.class.name
      when 'Quest' then 'info'
      when 'Campaign' then 'success'
      else ''
    end
  end

  # Will return count for search result of the result
  # @param result [String] class item
  # @return [String] count of search result
  def render_result_count(results)
    record = quest = campaign = 0
    results.each do |result|
      if Record.child_classes.to_s.include? result.class.name
        record += 1
      elsif result.class.name == 'Quest'
        quest += 1
      elsif result.class.name == 'Campaign'
        campaign += 1
      end
    end
    record_tag = content_tag(:span, record.to_s + ' Records', :class => 'label label-info', :style => 'margin: 3px 3px 3px 3px;')
    quest_tag = content_tag(:span, quest.to_s + ' Quests',:class => 'label label-primary', :style => 'margin: 3px 3px 3px 3px;')
    campaign_tag = content_tag(:span, campaign.to_s + ' Campaigns',:class => 'label label-success', :style => 'margin: 3px 3px 3px 3px;')
    arr = [record_tag, quest_tag, campaign_tag]
    content_tag(:div) do
      arr.each do |content|
        concat content
      end
    end
  end
end
