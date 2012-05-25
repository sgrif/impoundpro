module CapybaraFormMacros
  def fill_field (field, value, page)
    unless ["user_stripe_customer_token", "user_paid"].include?(field)
      if (value.in? States)
        page.select(States[value], :from => field.to_s)
      elsif (value.is_a?(String) || value.is_a?(Integer) || value.is_a?(Float))
        page.fill_in(field.to_s, :with => value)
      elsif (value.is_a?(Time))
        select_date(value.to_date, page, :label => field)
      else
        raise "Can't do anything with #{field}(#{value.class})"
      end
    end
  end

  def select_date (date, page, options = {})
    # lookup id prefix by label
    id_prefix = options[:label].to_s

    # select the appropriate date values
    page.select(date.year.to_s, :from => "#{id_prefix}_1i")
    page.select(date.strftime('%B'), :from => "#{id_prefix}_2i")
    page.select(date.day.to_s, :from => "#{id_prefix}_3i")
  end

  def fill_cc (cc_info, page)
    page.fill_in('card_number', :with => cc_info[:card_number].to_s)
    page.fill_in('card_code', :with => cc_info[:card_code].to_s)
    page.select(cc_info[:card_month].month.to_s, :from => 'card_month')
    page.select(cc_info[:card_year].year.to_s, :from => 'card_year')
  end
end
