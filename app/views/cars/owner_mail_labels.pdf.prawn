prawn_document(:margin => [20,20,20,20]) do |pdf|
  pdf.font_size 8
  pdf.text @car.user.name
  pdf.text @car.user.address
  pdf.text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}"
  pdf.text @car.user.phone_number

  pdf.font_size 12
  pdf.move_down 40
  pdf.text @car.owner_name || '', :align => :center
  pdf.text @car.owner_address || '', :align => :center
  pdf.text "#{@car.owner_city}, #{@car.owner_state} #{@car.owner_zip}", :align => :center
end
