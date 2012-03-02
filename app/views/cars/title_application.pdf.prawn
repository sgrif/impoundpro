prawn_document(margin: [10,10,10,10]) do |pdf|
  form_path = "#{Rails.root}/app/assets/images/05-Title_App-1.jpg"
  pdf.image form_path, width: 587, height: 733
  
  pdf.font_size 12
  pdf.draw_text @car.vin, at: [25, 700]
  pdf.draw_text @car.year, at: [215, 700]
  pdf.draw_text @car.make, at: [254, 700]
  pdf.draw_text @car.model, at: [320, 700]
  pdf.draw_text @car.color, at: [450, 700]
  
  pdf.draw_text @car.user.name, at: [25, 650]
  pdf.draw_text @car.user.address, at: [25, 635]
  pdf.draw_text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}", at: [25, 620]
  
  #TODO Which of these fields do I fill in?
  
  pdf.font_size 10
  pdf.draw_text @car.size, at: [350, 650]
  pdf.draw_text @car.license_plate_number, at: [260, 627]
  pdf.draw_text @car.make, at: [400, 627]
  pdf.draw_text @car.size, at: [430, 580]
  
  #TODO What to do for Lien Holder File Dates?
  
  pdf.font_size 12
  pdf.draw_text @car.lien_holder_name, at: [25, 500]
  pdf.draw_text @car.lien_holder_address, at: [25, 485]
  pdf.draw_text "#{@car.lien_holder_city}, #{@car.lien_holder_state} #{@car.lien_holder_zip}", at: [25, 470]
  
  #TODO Do I fill any of these?
  
  pdf.draw_text @car.user.name, at: [28, 250]
  pdf.draw_text Time.now.to_s(:short_date), at: [400, 250]
  
  pdf.draw_text @car.user.name, at: [28, 153]
  pdf.draw_text Time.now.to_s(:short_date), at: [400, 153]
  
  form_path = "#{Rails.root}/app/assets/images/05-Title_App-2.jpg"
  pdf.image form_path, width: 587, height: 572
end