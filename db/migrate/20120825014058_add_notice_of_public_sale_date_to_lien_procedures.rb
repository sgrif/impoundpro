class AddNoticeOfPublicSaleDateToLienProcedures < ActiveRecord::Migration
  def change
    add_column :lien_procedures, :notice_of_public_sale_date, :date
  end
end
