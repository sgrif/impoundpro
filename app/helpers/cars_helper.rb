module CarsHelper
  def class_for_status_label(status)
    case status
    when "active"
      "label label-success"
    else
      "label"
    end
  end

  def status_label(status)
    content_tag :span, status.capitalize, class: class_for_status_label(status)
  end
end
