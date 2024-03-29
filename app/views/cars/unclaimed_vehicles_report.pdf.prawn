prawn_document(:margin => [15,15,15,15], :page_layout => :landscape) do |pdf|
  pages = (@cars.count/10.0).ceil
  (0..pages-1).each do |x|
    cars = @cars.slice(x*10, 10)

    pdf.image "#{Rails.root}/app/assets/images/03-30-Day-Unclaimed-Vehicles-Report.jpg", :width => 757, :height => 532

    pdf.font_size 10
    pdf.draw_text @current_user.name, :at => [5, 526]
    pdf.draw_text @current_user.address, :at => [120, 526]
    pdf.draw_text @current_user.zip, :at => [400, 526]
    pdf.draw_text @current_user.phone_number, :at => [600, 526]

    row_height = 29
    cars.each_with_index do |car, i|
      #TODO Should I get the LP year? - add to car setup
      #pdf.draw_text "#{car.id} #{x}", :at => [20, 367 - i * row_height]
      pdf.draw_text car.state, :at => [46, 367 - i * row_height]
      pdf.draw_text car.license_plate_number, :at => [71, 367 - i * row_height]
      pdf.draw_text car.vin, :at => [115, 367 - i * row_height]
      pdf.draw_text car.make, :at => [262, 367 - i * row_height]
      pdf.draw_text car.year_id, :at => [320, 367 - i * row_height]
      pdf.text_box car.size, :width => 30, :height => 28, :at => [353, 384 - i * row_height], :align => :center, :v_align => :center
      pdf.text_box "#{car.owner_name}, #{car.owner_address}", :width => 148, :height => 28, :at => [442, 384 - i * row_height], :align => :center, :v_align => :center
      pdf.draw_text car.active_lien_procedure.try { |l| l.date_towed.to_s(:short_date) }, :at => [596, 367 - i * row_height]
      pdf.draw_text car.active_lien_procedure.try(:tow_requester), :at => [651, 373 - i * row_height]
      pdf.draw_text car.active_lien_procedure.try(:tow_reason), :at => [651, 360 - i * row_height]
    end

  end
end
