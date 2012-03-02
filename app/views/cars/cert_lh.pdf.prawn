prawn_document() do |pdf|
  form_path = "#{Rails.root}/app/assets/images/01-Lien-Notice.jpg"
  pdf.image form_path, :width => 571, :height => 746, :at => [-20, 740]
  
  pdf.draw_text "X", :at => [152, 625] if @car.has_lien_holder
  pdf.draw_text @car.lien_holder_name, :at => [35, 600]
  pdf.draw_text @car.lien_holder_address, :at => [45, 570]
  pdf.draw_text "#{@car.lien_holder_city}, #{@car.lien_holder_state}, #{@car.lien_holder_zip}", :at => [120, 540]
  
  pdf.font_size 16
  pdf.draw_text @car.year, :at => [0, 485]
  pdf.draw_text @car.make, :at => [80, 485]
  pdf.draw_text @car.model, :at => [200, 485]
  pdf.draw_text @car.size, :at => [330, 485]
  pdf.draw_text @car.state, :at => [470, 485]
  
  pdf.draw_text @car.vin, :at => [210, 450]
  pdf.draw_text @car.license_plate_number, :at => [420, 450]
  
  pdf.font_size 12
  pdf.draw_text "X", :at => [30, 404] if @car.has_charges
  pdf.draw_text number_to_currency(@car.charge_total, :format => "%n"), :at => [410, 406]
  pdf.draw_text number_to_currency(@car.charge_towing, :format => "%n"), :at => [410, 377]
  pdf.draw_text number_to_currency(@car.charge_storage, :format => "%n"), :at => [410, 360]
  pdf.draw_text number_to_currency(@car.charge_admin, :format => "%n"), :at => [410, 343]
  pdf.draw_text number_to_currency(@car.storage_rate, :format => "%n"), :at => [35, 298]
  
  pdf.font_size 10
  pdf.draw_text @car.date_towed.to_s(:month_and_day), :at => [370, 260]
  pdf.draw_text @car.date_towed.to_s(:short_year), :at => [470, 260]
  
  pdf.draw_text Time.now.to_s(:month_and_day), :at => [40, 248]
  pdf.draw_text Time.now.to_s(:short_year), :at => [140, 248]
  
  pdf.font_size 16
  pdf.draw_text @car.user.name, :at => [0, 210]
  pdf.draw_text @car.user.address, :at => [0, 174]
  pdf.draw_text "#{@car.user.city}, #{@car.user.state}, #{@car.user.zip}", :at => [0, 140]
  
  pdf.draw_text @car.preparers_name, :at => [130, 80]
  pdf.font_size 12
  pdf.draw_text Date.today.to_s(:long), :at => [440, 30]
end