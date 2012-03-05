prawn_document(margin: [15,15,15,15]) do |pdf|
  pdf.image "#{Rails.root}/app/assets/images/06-50-State-Check-1.jpg", width: 570, height: 743
  
  pdf.font_size 16
  pdf.draw_text States[@car.state], at: [210, 655]
  
  pdf.font_size 14
  pdf.draw_text @car.year, at: [20, 590]
  pdf.draw_text @car.make, at: [110, 590]
  pdf.draw_text @car.vin, at: [310, 590]
  
  #TODO Do I fill in title number or the check boxes or the agency info?
  
  pdf.draw_text @car.user.name, at: [60, 131] #TODO Do I need the NM - PRC number?
  pdf.draw_text @car.user.address, at: [80, 105]
  pdf.draw_text @car.user.phone_number, at: [460, 105]
  pdf.draw_text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}", at: [140, 80]
  pdf.draw_text Time.now.to_s(:short_date), at: [465, 50]
  
  pdf.image "#{Rails.root}/app/assets/images/06-50-State-Check-2.jpg", width: 570, height: 752
end
