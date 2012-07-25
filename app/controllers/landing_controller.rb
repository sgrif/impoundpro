class LandingController < ApplicationController
  skip_before_filter :authorize
  before_filter do
    if current_user
      redirect_to cars_path
    end
  end

  def home
  end

  def tour
  end

  def pricing
  end
end
