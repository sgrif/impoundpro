# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  car.setupForm()

car =
  setupForm: ->
    $('input.charge').change ->
      car.update_totals()

    $('input#car_tax').change ->
      car.update_totals()

    $('form#new_car').on 'keydown', 'input', (e) ->
      if e.keyCode is 13
        $('input:submit#new_car_submit').click()
        false
      else
        true

  true_tax: (tax) ->
    return tax + 1 if tax < 1
    return tax/100 + 1

  update_totals: () ->
    #TODO Calculate storage correctly
    charges = ((Number) elem.value for elem in $('.charge'))
    subtotal = charges.reduce (x, y) -> x + y
    total = subtotal * car.true_tax (Number) $('#car_tax').val()
    $('#car_charge_subtotal').val(subtotal.toFixed(2))
    $('#car_charge_total').val(total.toFixed(2))
