class CarStepsController < ApplicationController
  include Wicked::Wizard
  steps :car_info, :tow_info

  def show
    @car = Car.find(params[:id])
    render_wizard
  end
end
