prawn_document(:margin => [20, 20, 20, 20]) do |pdf|
  form_path = "#{Rails.root}/app/assets/images/04-Affidavit-of-Resale-1.jpg"
  pdf.image form_path, :width => 558, :height => 731

  pdf.font_size 10
  pdf.draw_text @car.owner_name, :at => [15, 592]
  pdf.draw_text @car.owner_address, :at => [15, 565]
  pdf.draw_text "#{@car.owner_city}, #{@car.owner_state}, #{@car.owner_zip}", :at => [15, 540] if @car.owner_city and @car.owner_state and @car.owner_zip

  pdf.draw_text @car.year_id, :at => [15, 495]
  pdf.draw_text @car.make, :at => [95, 495]
  pdf.draw_text @car.model, :at => [240, 495]
  pdf.draw_text @car.size, :at => [365, 495]
  pdf.draw_text @car.state, :at => [460, 495]

  pdf.draw_text @car.vin, :at => [165, 469]
  pdf.draw_text @car.license_plate_number, :at => [365, 469]

  #TODO Do I leave the "vehicle was advertised" section blank?

  pdf.font_size 12
  if @car.active_lien_procedure.try :lien_notice_mail_date
    pdf.draw_text((@car.active_lien_procedure.lien_notice_mail_date + 44.days).to_s(:month_and_day), :at => [225, 222])
    pdf.draw_text((@car.active_lien_procedure.lien_notice_mail_date + 44.days).to_s(:short_year), :at => [425, 222])
  end

  #TODO Is this date always 44 days after lien notice mail date - cahngeable and is it always at 5 PM - changeable?

  pdf.draw_text @car.user.county, :at => [100, 202]
  pdf.draw_text @car.user.address, :at => [20, 183]
  pdf.draw_text @car.user.city, :at => [240, 183]
  pdf.draw_text @car.user.state, :at => [425, 183]
  pdf.draw_text @car.user.zip, :at => [490, 183]

  form_path = "#{Rails.root}/app/assets/images/04-Affidavit-of-Resale-2.jpg"
  pdf.image form_path, :width => 556, :height => 747

  #TODO What do I do with the "Public Auction Information Continued" and "Odometer Milage Statements"?
  #TODO Add charge total - leave other fields blank

  pdf.font_size 14
  pdf.draw_text @car.user.name, :at => [90, 403]
  pdf.draw_text @car.user.address, :at => [90, 377]
  pdf.draw_text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}", :at => [130, 350]
  pdf.draw_text Date.today.to_s(:short_date), :at =>[475, 308]
  pdf.draw_text Date.today.to_s(:short_date), :at =>[475, 207]

  #TODO Do I leave "Lien Claimant printed name" blank? - Preparer's name or company name
end
