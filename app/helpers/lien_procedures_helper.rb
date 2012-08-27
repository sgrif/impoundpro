module LienProceduresHelper
  def new_or_edit_lp_path(car, lien_procedure)
    if lien_procedure.try(:id).nil?
      new_car_lien_procedure_path(car)
    else
      edit_car_lien_procedure_path(car, lien_procedure)
    end
  end
end
