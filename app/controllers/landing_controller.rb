class LandingController < ApplicationController
  skip_before_filter :authorize

  def home
  end

  def tour
  end

  def pricing
  end
end
