prawn_document(:margin => [20,20,20,20]) do |pdf|
  pdf.font_size 8
  pdf.text @car.user.name
  pdf.text @car.user.address
  pdf.text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}"
  pdf.text @car.user.phone_number

  pdf.font_size 12
  pdf.move_down 40
  if @car.active_lien_procedure
    pdf.text @car.active_lien_procedure.driver_name, :align => :center
    pdf.text @car.active_lien_procedure.driver_address, :align => :center
    pdf.text @car.active_lien_procedure.driver_csz_string, :align => :center
  end
end
