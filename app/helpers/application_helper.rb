module ApplicationHelper
  def cp(paths)
    Array.wrap(paths).each do |path|
      return "active" if current_page?(path)
    end
    nil
  end

  def icon_tag(icon, *args)
    options = args.extract_options!
    text = args.first || options.delete(:text)
    if text.nil?
      content_tag :i, "", class: ["icon", "icon-#{icon}"] + options[:class].to_a
    else
      "#{icon_tag icon} #{text}".html_safe
    end
  end
  def render_breadcrumbs(divider = '/')
    render :partial => 'twitter-bootstrap/breadcrumbs', :locals => { :divider => divider }
  end
end
