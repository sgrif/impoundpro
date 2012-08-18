class LienProcedure < ActiveRecord::Base
  validates :car_id, presence: true
  validates :active, uniqueness: { scope: :car_id, message: "This vehicle already has an active lien procedure", if: :active }

  attr_protected :car_id

  belongs_to :car

  scope :test_scope, where(active: true)

  def status
    active ? "active" : "inactive"
  end
end
