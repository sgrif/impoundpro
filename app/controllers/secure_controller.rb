class SecureController < ApplicationController
  skip_before_filter :has_subscription, only: :dashboard

  def dashboard
  end

  def reports
  end
end
