# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
true_tax = (tax) ->
  return tax + 1 if tax < 1
  return tax/100 + 1
  
update_totals = () ->
  charges = ((Number) elem.value for elem in $('.charge'))
  subtotal = charges.reduce (x, y) -> x + y
  total = subtotal * true_tax (Number) $('#car_tax').val()
  $('#car_charge_subtotal').val(subtotal)
  $('#car_charge_total').val(Math.round(total * 100)/100)

jQuery ->
  $('input.charge').change ->
    update_totals()
    
  $('input#car_tax').change ->
    update_totals()
