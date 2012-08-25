module CarsHelper
  def class_for_status_label(*args)
    options = args.extract_options!
    options[:type] ||= "label"

    case args.first
    when "active"
      "#{options[:type]} #{options[:type]}-info"
    when "claimed", "titled"
      "#{options[:type]} #{options[:type]}-inverse"
    when "action soon"
      "#{options[:type]} #{options[:type]}-warning"
    when "action required"
      "#{options[:type]} #{options[:type]}-important"
    when "ready to title"
      "#{options[:type]} #{options[:type]}-success"
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
    if path.is_a?(Array)
      path_options = path.extract_options!
      path_options[:action] = :edit if path_options[:action].nil?
      path = polymorphic_path(path, path_options)
    end

    if args.first or args.second
      link_to "<i class='icon-check#{"-empty" if args.second}'></i> #{name}".html_safe, "#", class: "#{html_options[:class]} disabled"
    else
      link_to "<i class='icon-check-empty'></i> #{name}".html_safe, path, html_options
    end
  end

  def lien_procedure_info_button(car)
    ret = Hash.new
    ret[:hide] = "true"
    ret[:show_text] = "#{car.active_lien_procedure.nil? ? "Add" : "Edit"} Lien Procedure"
    ret[:btn_class] = "info" if car.active_lien_procedure
    ret[:btn_icon] = "edit" if car.active_lien_procedure
    ret[:remove_content] = "true" if car.active_lien_procedure.nil?
    ret
  end
end
