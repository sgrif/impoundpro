prawn_document(margin: [20,20,20,20]) do |pdf|
  pdf.font_size 8
  pdf.text @car.user.name
  pdf.text @car.user.address
  pdf.text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}"
  pdf.text @car.user.phone_number
  
  pdf.font_size 12
  pdf.move_down 40
  pdf.text @car.lien_holder_name, align: :center
  pdf.text @car.lien_holder_address, align: :center
  pdf.text "#{@car.lien_holder_city}, #{@car.lien_holder_state} #{@car.lien_holder_zip}", align: :center
end
