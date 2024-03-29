class LienProcedure < ActiveRecord::Base
  validates :car_id, presence: true
  validates :active, uniqueness: { scope: :car_id, message: "This vehicle already has an active lien procedure", if: :active }
  validates :date_towed, presence: true

  validate :validate_dates

  before_create { date_towed ||= Date.today }

  attr_protected :car_id

  belongs_to :car

  def titled= (titled)
    self.active = false if titled
    write_attribute(:titled, titled)
  end

  def scrapped= (scrapped)
    self.active = false if scrapped
    write_attribute(:scrapped, scrapped)
  end

  def claimed= (claimed)
    self.active = false if claimed
    write_attribute(:claimed, claimed)
  end

  def status
    if active
      ret ||= self.send "#{next_step}_action"
      ret ||= "active"
    end
    ret ||= "inactive"
  end

  def titled_action
  end

  def notice_of_public_sale_date_action
    return "action required" if lien_notice_mail_date <= 10.days.ago.to_date
    return "action soon" if lien_notice_mail_date <= 8.days.ago.to_date
  end

  def lien_notice_mail_date_action
    return "action required" if mvd_inquiry_date <= 5.days.ago.to_date
    return "action soon" if mvd_inquiry_date <= 3.days.ago.to_date
  end

  def mvd_inquiry_date_action
    return "action required" if date_towed <= 2.days.ago.to_date
    return "action soon" if date_towed == Date.yesterday
  end

  def next_step_string
    case next_step
    when :mvd_inquiry_date
      "Request MVR"
    when :lien_notice_mail_date
      "Mail Lien Notice(s)"
    when :notice_of_public_sale_date
      "Post Notice of Sale"
    when :titled
      "Title or Scrap"
    end
  end

  def next_step
    if !active_was
      :none
    elsif date_towed_was.nil?
      :date_towed
    elsif mvd_inquiry_date_was.nil?
      :mvd_inquiry_date
    elsif lien_notice_mail_date_was.nil?
      :lien_notice_mail_date
    elsif notice_of_public_sale_date_was.nil?
      :notice_of_public_sale_date
    else
      :titled
    end
  end

  def completed_steps
    ret = Array.new
    ret << :date_towed unless date_towed_was.nil?
    ret << :mvd_inquiry_date unless mvd_inquiry_date_was.nil?
    ret << :lien_notice_mail_date unless lien_notice_mail_date_was.nil?
    ret << :notice_of_public_sale_date unless notice_of_public_sale_date_was.nil?
    ret << :titled unless active
    ret
  end

  def driver_csz_string
    fields = Array.new
    fields << driver_city if driver_city.present?
    fields << driver_state if driver_state.present?
    fields << driver_zip if driver_zip.present?
    fields.join ", "
  end

  def self.action_soon
    where self._action_soon
  end

  def self._action_soon
    t = arel_table
    t[:mvd_inquiry_date].eq(nil).and(t[:date_towed].eq(Date.yesterday))
      .or(t[:lien_notice_mail_date].eq(nil)
        .and(t[:mvd_inquiry_date].in(4.days.ago.to_date..3.days.ago.to_date)))
      .or(t[:notice_of_public_sale_date].eq(nil)
        .and(t[:lien_notice_mail_date].in(9.days.ago.to_date..8.days.ago.to_date)))
  end

  def self.action_required
    where self._action_required
  end

  def self._action_required
    t = arel_table
    t[:mvd_inquiry_date].eq(nil).and(t[:date_towed].lteq(2.days.ago.to_date))
      .or(t[:lien_notice_mail_date].eq(nil).and(t[:mvd_inquiry_date].lteq(5.days.ago.to_date)))
      .or(t[:notice_of_public_sale_date].eq(nil).and(t[:lien_notice_mail_date].lteq(10.days.ago.to_date)))
  end

  protected

  def validate_dates
    errors.add :date_towed, "must be before today's date" if date_towed_changed? and date_towed > Date.today
    errors.add :mvd_inquiry_date, "must be after tow date" if date_towed.nil? or (mvd_inquiry_date.present? and mvd_inquiry_date < date_towed)
    errors.add :lien_notice_mail_date, "must be after mvd inquiry date" if lien_notice_mail_date.present? and (mvd_inquiry_date.nil? or lien_notice_mail_date < mvd_inquiry_date)
  end
end
