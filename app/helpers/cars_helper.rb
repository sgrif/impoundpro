module CarsHelper
  def filter_years(car)
    if car.trim
      car.trim.years
    elsif car.model
      car.model.years
    elsif car.make
      car.make.years
    else
      Year.all
    end
  end

  def filter_trims(car)
    if car.year
      car.year.trims
    elsif car.model
      car.model.trims
    end
  end
end
