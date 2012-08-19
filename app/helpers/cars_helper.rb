module CarsHelper
  def class_for_status_label(*args)
    options = args.extract_options!
    options[:type] ||= "label"

    case args.first
    when "active"
      "#{options[:type]} #{options[:type]}-success"
    when "claimed"
      "#{options[:type]} #{options[:type]}-inverse"
    when "attention needed"
      "#{options[:type]} #{options[:type]}-warning"
    when "action required"
      "#{options[:type]} #{options[:type]}-important"
    else
      "#{options[:type]}"
    end
  end

  def status_label(status)
    content_tag :span, status.capitalize, class: class_for_status_label(status)
  end

  def status_badge(status, count)
    content_tag :span, count, class: class_for_status_label(status, type: "badge")
  end

  def car_step_tag(name, path, *args)
    html_options = args.extract_options!
    if args.first or args.second
      content_tag :span, "<i class='icon-check#{"-empty" if args.second}'></i> #{name}".html_safe, class: "btn disabled"
    else
      html_options[:class] = "btn"
      link_to "<i class='icon-check-empty'></i> #{name}".html_safe, path, html_options
    end
  end
end
