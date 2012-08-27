class AddLienNoticeMailDateToLienProcedures < ActiveRecord::Migration
  def change
    add_column :lien_procedures, :lien_notice_mail_date, :date
  end
end
