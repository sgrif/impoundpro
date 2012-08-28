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
      path = polymorphic_path(path, path_options)
    end

    if args.first or args.second
      link_to icon_tag(args.first ? "check" : "check-empty", name), "#", class: "#{html_options[:class]} disabled"
    else
      link_to icon_tag('check-empty', name), path, html_options
    end
  end

  def car_date_step_tag(title, car, lien_procedure, field)
    car_step_tag title, [car, lien_procedure, "lien_procedure[#{field}]" => Date.current, action: :edit], lien_procedure.try(field), lien_procedure.try(:next_step) != field.to_sym
  end

  def lien_procedure_info_button(lien_procedure)
    ret = Hash.new
    ret[:hide] = "true"
    ret[:show_text] = "#{lien_procedure.new_record? ? "Add" : "Edit"} Lien Procedure"
    ret[:btn_class] = "info" unless lien_procedure.new_record?
    ret[:btn_icon] = "edit" unless lien_procedure.new_record?
    ret[:remove_content] = "true" if lien_procedure.new_record?
    ret
  end
end
