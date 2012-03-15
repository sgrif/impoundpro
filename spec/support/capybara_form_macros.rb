module CapybaraFormMacros
  def fill_field (field, value, page)
    if (value.in? States)
      page.select(States[value], :from => field)
    elsif (value.is_a?(String) || value.is_a?(Integer) || value.is_a?(Float))
      page.fill_in(field, :with => value)
    elsif (value.is_a?(Time))
      select_date(value.to_date, page, :label => field)
    else
      raise "Can't do anything with #{field}(#{value.class})"
    end
  end
  
  def select_date (date, page, options = {})
    # lookup id prefix by label
    id_prefix = options[:label]
  
    # select the appropriate date values
    page.select(date.year.to_s, :from => "#{id_prefix}_1i")
    page.select(date.strftime('%B'), :from => "#{id_prefix}_2i")
    page.select(date.day.to_s, :from => "#{id_prefix}_3i")
  end
end