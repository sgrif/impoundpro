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

    $('.forms_overlay td').width ->
        $(this).parent()
          .next('.forms')
          .width()

    $('.forms_overlay td').height ->
      $(this).parent()
        .next('.forms')
        .height()

    $('select#car_size').change ->
      if $(this).val() == 'Other'
        $(this).attr('name', '')
        $(this).after('<input type="text" name="car[size]" />')

    $('input.combobox').each ->
      $(this).combobox()

  true_tax: (tax) ->
    return tax + 1 if tax < 1
    return tax/100 + 1

  update_totals: () ->
    charges = ((Number) elem.value for elem in $('.charge'))
    subtotal = charges.reduce (x, y) -> x + y
    total = subtotal * car.true_tax (Number) $('#car_tax').val()
    $('#car_charge_subtotal').val(subtotal.toFixed(2))
    $('#car_charge_total').val(total.toFixed(2))
