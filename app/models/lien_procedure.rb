class LienProcedure < ActiveRecord::Base
  validates :car_id, presence: true
  validates :active, uniqueness: { scope: :car_id, message: "This vehicle already has an active lien procedure", if: :active }
  validates :date_towed, presence: true

  validate :validate_dates

  before_create { date_towed ||= Date.today }

  attr_protected :car_id

  belongs_to :car

  def status
    if active
      if notice_of_public_sale_date.present?
        return "action required" if lien_notice_mail_date <= 10.days.ago.to_date
        return "action soon" if lien_notice_mail_date <= 8.days.ago.to_date
      elsif lien_notice_mail_date.present?
        return "action required" if mvd_inquiry_date <= 5.days.ago.to_date
        return "action soon" if mvd_inquiry_date <= 3.days.ago.to_date
      elsif date_towed.present?
        return "action required" if date_towed <= 2.days.ago.to_date
        return "action soon" if date_towed == Date.yesterday
      end
      "active"
    else
      "inactive"
    end
  end

  def next_step_string
    case next_step
    when :mvd_inquiry_date
      "MVD Motor Vehicle Record Request"
    when :lien_notice_mail_date
      "Mail Lien Notice"
    when :notice_of_public_sale_date
      "Post Notice of Public Sale"
    end
  end

  def next_step
    if date_towed.nil?
      :date_towed
    elsif mvd_inquiry_date.nil?
      :mvd_inquiry_date
    elsif lien_notice_mail_date.nil?
      :lien_notice_mail_date
    elsif notice_of_public_sale_date.nil?
      :notice_of_public_sale_date
    end
  end

  def completed_steps
    ret = Array.new
    ret << :date_towed unless date_towed.nil?
    ret << :mvd_inquiry_date unless mvd_inquiry_date.nil?
    ret << :lien_notice_mail_date unless lien_notice_mail_date.nil?
    ret << :notice_of_public_sale_date unless notice_of_public_sale_date.nil?
    ret
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
