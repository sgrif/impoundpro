class AddMailNoticeOfLienDateToCars < ActiveRecord::Migration
  def change
    add_column :cars, :mail_notice_of_lien_date, :date
  end
end
