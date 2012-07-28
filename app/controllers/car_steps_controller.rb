class CarStepsController < ApplicationController
  include Wicked::Wizard
  steps :persistent, :tow

  def show
    render_wizard
  end
end
