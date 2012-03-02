prawn_document(margin: [15, 15, 15, 15]) do |pdf|
  form_path = "#{Rails.root}/app/assets/images/04-Affidavit-of-Resale-1.jpg"
  pdf.image form_path
  
  pdf.font_size 10
  pdf.draw_text @car.owner_name, at: [15, 598]
  pdf.draw_text @car.owner_address, at: [15, 570]
  pdf.draw_text "#{@car.owner_city}, #{@car.owner_state}, #{@car.owner_zip}", at: [15, 544]
  
  pdf.draw_text @car.year, at: [15, 498]
  pdf.draw_text @car.make, at: [95, 498]
  pdf.draw_text @car.model, at: [240, 498]
  pdf.draw_text @car.size, at: [365, 498]
  pdf.draw_text @car.state, at: [460, 498]
  
  pdf.draw_text @car.vin, at: [165, 472]
  pdf.draw_text @car.license_plate_number, at: [365, 472]
  
  #TODO Do I leave the "vehicle was advertised" section blank?
  
  pdf.font_size 12
  pdf.draw_text (@car.mail_notice_of_lien_date + 44.days).to_s(:month_and_day), at: [235, 218]
  pdf.draw_text (@car.mail_notice_of_lien_date + 44.days).to_s(:short_year), at: [440, 218]
  
  #TODO Is this date always 44 days after lien notice mail date and is it always at 5 PM?
  
  pdf.draw_text @car.user.county, at: [115, 198]
  pdf.draw_text @car.user.address, at: [20, 177]
  pdf.draw_text @car.user.city, at: [250, 177]
  pdf.draw_text @car.user.state, at: [435, 177]
  pdf.draw_text @car.user.zip, at: [500, 177]
  
  #TODO Is this always the address given during registration?

  form_path = "#{Rails.root}/app/assets/images/04-Affidavit-of-Resale-2.jpg"
  pdf.image form_path
  
  #TODO What do I do with the "Public Auction Information Continued" and "Odometer Milage Statements"?
  
  pdf.font_size 14
  pdf.draw_text @car.user.name, at: [90, 415]
  pdf.draw_text @car.user.address, at: [90, 387]
  pdf.draw_text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}", at: [130, 358]
  pdf.draw_text Time.now.to_s(:short_date), at:[483, 317]
  pdf.draw_text Time.now.to_s(:short_date), at:[483, 215]
  
  #TODO Do I leave "Lien Claimant printed name" blank?
end
