prawn_document(:margin => [15,15,15,15], :page_layout => :landscape) do |pdf|
  x = 0
  while x < @cars.count
    cars = @cars.slice(x, 10)
    
    pdf.image "#{Rails.root}/app/assets/images/03-30-Day-Unclaimed-Vehicles-Report.jpg", :width => 757, :height => 532
    
    pdf.font_size 10
    pdf.draw_text @user.name, :at => [5, 526]
    pdf.draw_text @user.address, :at => [120, 526]
    pdf.draw_text @user.zip, :at => [400, 526]
    pdf.draw_text @user.phone_number, :at => [600, 526]
    
    row_height = 29
    cars.each_with_index do |car, i|
      #TODO Should I get the LP year? - add to car setup
      pdf.draw_text "#{car.id} #{x}", :at => [20, 367 - i * row_height]
      pdf.draw_text car.state, :at => [46, 367 - i * row_height]
      pdf.draw_text car.license_plate_number, :at => [71, 367 - i * row_height]
      pdf.draw_text car.vin, :at => [115, 367 - i * row_height]
      pdf.draw_text car.make, :at => [262, 367 - i * row_height]
      pdf.draw_text car.year, :at => [320, 367 - i * row_height]
      pdf.text_box car.size, :width => 30, :height => 28, :at => [353, 384 - i * row_height], :align => :center, :v_align => :center
      pdf.text_box "#{car.owner_name}, #{car.owner_address}", :width => 148, :height => 28, :at => [442, 384 - i * row_height], :align => :center, :v_align => :center
      pdf.draw_text car.date_towed.to_s(:short_date), :at => [596, 367 - i * row_height]
      pdf.draw_text car.tow_requested_by, :at => [651, 373 - i * row_height]
      pdf.draw_text car.tow_reason, :at => [651, 360 - i * row_height]
    end
    
    x += 10
  end
end
