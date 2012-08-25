class LienProcedure < ActiveRecord::Base
  validates :car_id, presence: true
  validates :active, uniqueness: { scope: :car_id, message: "This vehicle already has an active lien procedure", if: :active }

  validate :validate_dates

  before_create { date_towed ||= Date.today }

  attr_protected :car_id

  belongs_to :car

  scope :test_scope, where(active: true)

  def status
    if active
      if mvd_inquiry_date.nil? and date_towed <= 2.days.ago.to_date
        "action required"
      elsif mvd_inquiry_date.nil? and date_towed == Date.yesterday
        "action soon"
      elsif lien_notice_mail_date.nil? and mvd_inquiry_date <= 5.days.ago.to_date
        "action required"
      elsif lien_notice_mail_date.nil? and mvd_inquiry_date <= 3.days.ago.to_date
        "action soon"
      else
        "active"
      end
    else
      "inactive"
    end
  end

  def next_step
    if mvd_inquiry_date.nil?
      "MVD Motor Vehicle Record Request"
    elsif lien_notice_mail_date.nil?
      "Mail Lien Notice"
    end
  end

  def self.action_soon
    t = arel_table
    where t[:mvd_inquiry_date].eq(nil).and(t[:date_towed].eq(Date.yesterday))
      .or t[:lien_notice_mail_date].eq(nil)
        .and(t[:mvd_inquiry_date].in(4.days.ago.to_date..3.days.ago.to_date))
  end

  def self.action_required
    t = arel_table
    where t[:mvd_inquiry_date].eq(nil).and(t[:date_towed].lteq(2.days.ago.to_date))
      .or(t[:lien_notice_mail_date].eq(nil).and(t[:mvd_inquiry_date].lteq(5.days.ago.to_date)))
  end

  protected

  def validate_dates
    errors.add :date_towed, "must be after today's date" if date_towed_changed? and date_towed < Date.today
    errors.add :mvd_inquiry_date, "must be after tow date" if mvd_inquiry_date < date_towed
    errors.add :lien_notice_mail_date, "must be after mvd inquiry date" if lien_notice_mail_date < mvd_inquiry_date
  end
end
