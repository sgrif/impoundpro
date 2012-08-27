prawn_document() do |pdf|
  form_path = "#{Rails.root}/app/assets/images/01-Lien-Notice.jpg"
  pdf.image form_path, :width => 571, :height => 746, :at => [-20, 740]

  pdf.draw_text "X", :at => [241, 625]
  pdf.draw_text "Driver", :at => [300, 625]
  if @car.active_lien_procedure
    pdf.draw_text @car.active_lien_procedure.driver_name, :at => [35, 600]
    pdf.draw_text @car.active_lien_procedure.driver_address, :at => [45, 570]
    pdf.draw_text @car.active_lien_procedure.driver_csz_string, :at => [120, 540]
  end

  pdf.font_size 16
  pdf.draw_text @car.year_id, :at => [0, 485]
  pdf.draw_text @car.make, :at => [80, 485]
  pdf.draw_text @car.model, :at => [200, 485]
  pdf.draw_text @car.size, :at => [330, 485]
  pdf.draw_text @car.state, :at => [470, 485]

  pdf.draw_text @car.vin, :at => [210, 450]
  pdf.draw_text @car.license_plate_number, :at => [420, 450]

  pdf.font_size 12
  pdf.draw_text "X", :at => [30, 404]
#  pdf.draw_text number_to_currency(@car.charge_total, :format => "%n"), :at => [410, 406]
#  if @car.charges.count <= 4
#    i = 0
#    @car.charges.each do |name, amount|
#      pdf.draw_text name, :at => [100, 377 - i]
#      pdf.draw_text number_to_currency(amount, :format => "%n"), :at => [410, 377 - i]
#      i += 17
#    end
#  else
#    pdf.font_size 16
#    pdf.draw_text "See attached page", :at => [200, 377]
#    pdf.font_size 12
#  end

#  pdf.font_size 10
#  pdf.draw_text number_to_currency(@car.storage_rate, :format => "%n"), :at => [40, 297]

#  pdf.font_size 10
#  pdf.draw_text @car.date_towed.to_s(:month_and_day), :at => [370, 260]
#  pdf.draw_text @car.date_towed.to_s(:short_year), :at => [470, 260]

  pdf.draw_text Time.now.to_s(:month_and_day), :at => [40, 248]
  pdf.draw_text Time.now.to_s(:short_year), :at => [140, 248]

  pdf.font_size 16
  pdf.draw_text @car.user.name, :at => [0, 210]
  pdf.draw_text @car.user.address, :at => [0, 174]
  pdf.draw_text "#{@car.user.city}, #{@car.user.state}, #{@car.user.zip}", :at => [0, 140]

  pdf.draw_text @car.user.preparers_name, :at => [130, 80]
  pdf.font_size 12
  pdf.draw_text Date.today.to_s(:long), :at => [440, 30]

#  if @car.charges.count > 4
#    pdf.start_new_page()
#
#    pdf.font_size 18
#    pdf.text "Charges"
#    pdf.font_size 14
#
#    charges = @car.charges
#    charges.delete("Tax")
#
#    charges.each do |name, amount|
#      pdf.text "#{name}: #{number_to_currency(amount)}"
#    end
#    pdf.text "---------"
#    pdf.text "Subtotal: #{number_to_currency(@car.charge_subtotal)}"
#    pdf.text "Tax: #{number_to_currency(@car.tax_amount)}"
#    pdf.text "---------"
#    pdf.text "Total: #{number_to_currency(@car.charge_total)}"
#  end
end
