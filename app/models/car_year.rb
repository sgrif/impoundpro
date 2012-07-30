class CarYear < ActiveRecord::Base
  has_and_belongs_to_many :car_models do
    def by_make(make)
      find_all_by_make_id(make)
    end
  end
  has_and_belongs_to_many :car_trims do
    def by_model(model)
      find_all_by_car_model_id(model)
    end
  end
end
