class LienProcedure < ActiveRecord::Base
  validates :car_id, presence: true
  validates :active, uniqueness: { scope: :car_id, message: "This vehicle already has an active lien procedure", if: :active }

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
    end
  end

  def self.action_soon
    where({mvd_inquiry_date: nil}).where(date_towed: Date.yesterday)
  end

  def self.action_required
    where({mvd_inquiry_date: nil}).where('date_towed <= ?', 2.days.ago.to_date)
  end
end
