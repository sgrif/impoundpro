prawn_document() do |pdf|
  
  pdf.move_up 15
  pdf.text 'Notice of Public Sale', align: :center, style: :bold, size: 16
  
  pdf.move_down 30
  pdf.text "<u>Location of Sale:</u>   #{@car.user.name}", inline_format: true
  pdf.span(pdf.bounds.width - 100, position: 100) do
    pdf.text @car.user.address
    pdf.text "#{@car.user.city}, #{@car.user.state} #{@car.user.zip}"
  end
  
  pdf.move_down 35
  pdf.font_size 10
  pdf.text 'Notice of Public Sale', align: :center, style: :bold, leading: 2
  pdf.text "State of #{state_abbr_to_full(@car.user.state)}", align: :center, style: :bold, leading: 2
  pdf.text "County of #{@car.user.county}", align: :center, style: :bold
  
  pdf.move_down 20
  pdf.font_size 12
  pdf.text "<u>On: #{(@car.mail_notice_of_lien_date + 44.days).to_s(:short_date)}</u> at 5:00 pm the undersigned will offer to tell the following described vehicle to satisfy the charges for towing, storage, labor, and any other charges against the vehicle listed below.", inline_format: true
  
  pdf.move_down 50
  pdf.font_size 14
  pdf.span(pdf.bounds.width - 10, position: 10) do
    pdf.text "<u>Year:</u>   #{@car.year}      <u>Make:</u>   #{@car.make}      <u>Model:</u>   #{@car.model}", inline_format: true, leading: 30
    pdf.text "<u>VIN:</u>   #{@car.vin}   <u>Titled:</u>   #{@car.owner_name}   <u>LP #:</u>   #{@car.license_plate_number}", inline_format: true
  end
    
  pdf.move_down 15
  pdf.text "<u>Total Amount Owed:</u>   #{number_to_currency(@car.charge_total)}", inline_format: true
  
  pdf.move_down 30
  pdf.font_size 12
  pdf.text '<font size="16">Terms:</font> CASH IN HAND ON DAY OF SALE', style: :bold, inline_format: true
  
  pdf.move_down 35
  pdf.text "Date of receipt of return of lien notice: <u>   #{@car.mail_notice_of_lien_date.to_s(:short_date)}</u>", inline_format: true, leading: 30
  pdf.text "Signed by #{@car.user.name} / Attest: ______________________________________", leading: 30
  pdf.text "Date of Posting: <u>   #{(@car.mail_notice_of_lien_date + 10.days).to_s(:short_date)}</u>", inline_format: true
end
