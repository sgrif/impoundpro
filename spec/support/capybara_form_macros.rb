module CapybaraFormMacros
  def fill_field (field, value)
    if (value.in? States)
      select(States[value], :from => field)
    elsif (value.is_a?(String) || value.is_a?(Integer))
      fill_field(field, :with => value)
    elsif (value.is_a?(DateTime))
      select_date(date, :label => field)
    end
  end
  
  def select_date (date, options = {})
    date = Date.parse(date)
  
    # lookup id prefix by label
    id_prefix = id_prefix_for(options[:label])
  
    # select the appropriate date values
    select(date.year.to_s, :from => "#{id_prefix}_1i")
    select(date.strftime('%B'), :from => "#{id_prefix}_2i")
    select(date.day.to_s, :from => "#{id_prefix}_3i")
  end
end