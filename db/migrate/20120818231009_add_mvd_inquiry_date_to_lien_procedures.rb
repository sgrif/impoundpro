class AddMvdInquiryDateToLienProcedures < ActiveRecord::Migration
  def change
    add_column :lien_procedures, :mvd_inquiry_date, :date
  end
end
